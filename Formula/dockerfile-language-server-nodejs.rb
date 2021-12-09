require "language/node"

class DockerfileLanguageServerNodejs < Formula
  desc "Language server for Dockerfiles"
  homepage "https://github.com/rcjsuen/dockerfile-language-server-nodejs"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.7.2.tgz"
  sha256 "4318de559b9dedd40f1dc6e181f59bd10a3c4a37a84e0260f14fa340aa3b0952"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/dockerfile-language-server-nodejs-0.7.2"
    sha256 cellar: :any_skip_relocation, big_sur:      "0dd1ab056530c1389440329801e87aaf3b26a496b794dedf7920cb4b858d5cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fdded2dd596b879a9bda00ddfb0f16b9ed00215a508ebca773c376aa185239b3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "json"
    require "open3"

    def send_request(stdin, json)
      request = "Content-Length: #{json.size}\r\n\r\n#{json}"
      puts request
      stdin.write request
    end

    def send_notification(stdin, json)
      notification = "Content-Length: #{json.size}\r\n\r\n#{json}"
      puts notification
      stdin.write notification
    end

    def handle_response(id, stdout)
      header = nil
      json = nil
      response = nil
      loop do
        header = stdout.readline.chomp
        pattern = /Content-Length: (?<length>\d+)/
        assert_match pattern, header

        parts = header.match pattern
        content_length = Integer(parts["length"])

        spacer = stdout.readline.chomp
        assert_equal "", spacer

        json = stdout.readpartial(content_length)

        response = JSON.parse(json)

        break if response["id"] == id
      end
      puts "#{header}\r\n\r\n#{json}"
      response
    end

    exit_status = nil
    Open3.popen3("#{bin}/docker-langserver", "--stdio") do |stdin, stdout, _, wait_thr|
      ohai "Sending initialize request"
      send_request stdin, <<~JSON
        {
          "jsonrpc": "2.0",
          "id": 1,
          "method": "initialize",
          "params": {
            "rootUri": null,
            "capabilities": {}
          }
        }
      JSON

      ohai "Receiving initialize response"
      handle_response 1, stdout do |response|
        assert !response.key?("error"), "Response should not have 'error' key"
      end

      ohai "Sending initialized notification"
      send_notification stdin, <<~JSON
        {
          "jsonrpc": "2.0",
          "method": "initialized"
        }
      JSON

      ohai "Sending shutdown request"
      send_request stdin, <<~JSON
        {
          "jsonrpc": "2.0",
          "id": 2,
          "method": "shutdown",
          "params": null
        }
      JSON

      ohai "Receiving shutdown response"
      handle_response 2, stdout do |response|
        assert !response.key?("error"), "Response should not have 'error' key"
      end

      ohai "Sending exit notification"
      send_notification stdin, <<~JSON
        {
          "jsonrpc": "2.0",
          "method": "exit"
        }
      JSON

      ohai "Waiting for language server to exit"
      exit_status = wait_thr.value
    end
    assert exit_status.success?
  end
end
