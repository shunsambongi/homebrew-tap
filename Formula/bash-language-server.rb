require "language/node"

class BashLanguageServer < Formula
  desc "Language server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-2.0.0.tgz"
  sha256 "6e00d79e9ae95586c567c3919ee81c6e82bb7ef106e4bfaf3c84d3a94dccb20e"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/bash-language-server-2.0.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "bc32ce2e13d18ecdf4b8f88c618bab597d408d9764bf8f0447477cd4684ab392"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c6e4a332bd8c4c9cd4fa9df1ac35ff897467e6ea110f27727d092585e2fbe606"
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
    Open3.popen3("#{bin}/bash-language-server", "start") do |stdin, stdout, _, wait_thr|
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
