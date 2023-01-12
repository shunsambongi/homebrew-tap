require "language/node"

class VscodeLangserversExtracted < Formula
  desc "HTML/CSS/JSON language servers extracted from Visual Studio Code"
  homepage "https://github.com/hrsh7th/vscode-langservers-extracted"
  url "https://registry.npmjs.org/vscode-langservers-extracted/-/vscode-langservers-extracted-4.5.0.tgz"
  sha256 "5e3d3ddf64b4e339968e839f63935f3fd26064e34695e2feebbef1efcc413987"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/vscode-langservers-extracted-4.5.0"
    sha256 cellar: :any_skip_relocation, monterey:     "292104c4709cccdc575c9a24881bb4a10a59a1a9e25d8c8bc65f2f4fde8fc744"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "13b164c0c0f9b0ab529c8e4ffd77b969c1f7c67c3e0791b069544cbbf7b5ac8b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

    json = <<~JSON
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

    %w[HTML CSS JSON ESLint].each do |name|
      Open3.popen3("#{bin}/vscode-#{name.downcase}-language-server", "--stdio") do |stdin, stdout, _, _|
        stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
        sleep 3
        assert_match(/^Content-Length: \d+/i, stdout.readline)
      end
    end
  end
end
