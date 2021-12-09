require "language/node"

class VscodeLangserversExtracted < Formula
  desc "HTML/CSS/JSON language servers extracted from Visual Studio Code"
  homepage "https://github.com/hrsh7th/vscode-langservers-extracted"
  url "https://registry.npmjs.org/vscode-langservers-extracted/-/vscode-langservers-extracted-3.0.2.tgz"
  sha256 "cbe6e3a821875a94ba7185454f897cdd1be5f931faad99625a067cc0615f33ed"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/vscode-langservers-extracted-3.0.2"
    sha256 cellar: :any_skip_relocation, big_sur:      "b23577bb586ab318ce55bde6a9a77bf55c084d7f1f846952644b5b49fd7cbd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "50ca53d725f4d9fc376d24a8dd873910c78394147ed3e8557ccb068c1d7ca06e"
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

    %w[HTML CSS JSON ESLint].each do |name|
      exit_status = nil
      Open3.popen3("#{bin}/vscode-#{name.downcase}-language-server", "--stdio") do |stdin, stdout, _, wait_thr|
        ohai "#{name}: sending initialize request"
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

        ohai "#{name}: receiving initialize response"
        handle_response 1, stdout do |response|
          assert !response.key?("error"), "Response should not have 'error' key"
        end

        ohai "#{name}: sending initialized notification"
        send_notification stdin, <<~JSON
          {
            "jsonrpc": "2.0",
            "method": "initialized"
          }
        JSON

        ohai "#{name}: sending shutdown request"
        send_request stdin, <<~JSON
          {
            "jsonrpc": "2.0",
            "id": 2,
            "method": "shutdown",
            "params": null
          }
        JSON

        ohai "#{name}: receiving shutdown response"
        handle_response 2, stdout do |response|
          assert !response.key?("error"), "Response should not have 'error' key"
        end

        ohai "#{name}: sending exit notification"
        send_notification stdin, <<~JSON
          {
            "jsonrpc": "2.0",
            "method": "exit"
          }
        JSON

        ohai "#{name}: waiting for language server to exit"
        exit_status = wait_thr.value
      end
      assert exit_status.success?
    end
  end
end
