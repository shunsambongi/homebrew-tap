require "language/node"

class VscodeLangserversExtracted < Formula
  desc "HTML/CSS/JSON language servers extracted from Visual Studio Code"
  homepage "https://github.com/hrsh7th/vscode-langservers-extracted"
  url "https://registry.npmjs.org/vscode-langservers-extracted/-/vscode-langservers-extracted-4.5.0.tgz"
  sha256 "5e3d3ddf64b4e339968e839f63935f3fd26064e34695e2feebbef1efcc413987"
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
