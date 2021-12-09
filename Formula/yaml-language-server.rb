require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.2.2.tgz"
  sha256 "c5413137ec0ebf79a4368fd97611f2ae6d08a0c4ee2d6efb28763982a7e05e2a"
  license "MIT"

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
    Open3.popen3("#{bin}/yaml-language-server", "--stdio") do |stdin, stdout, _, wait_thr|
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
