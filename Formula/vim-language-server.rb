require "language/node"

class VimLanguageServer < Formula
  desc "VimScript langauge server"
  homepage "https://github.com/iamcco/vim-language-server"
  url "https://registry.npmjs.org/vim-language-server/-/vim-language-server-2.3.0.tgz"
  sha256 "45d6d3ddf354d281b050bb2a41faed840c0996b03705d04169787b4f91f96221"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/vim-language-server-2.2.5"
    sha256 cellar: :any_skip_relocation, big_sur:      "9275ecf4bb6879c0dc31183b24fe66b02ccff0f16319d370106f8f0bc6b39e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aeeddd38a7d012058ddc55f864625f16b1e94c7ba899b5514ff7c412c79d2e25"
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

    Open3.popen3("#{bin}/vim-language-server", "--stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
