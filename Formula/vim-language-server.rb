require "language/node"

class VimLanguageServer < Formula
  desc "VimScript langauge server"
  homepage "https://github.com/iamcco/vim-language-server"
  url "https://registry.npmjs.org/vim-language-server/-/vim-language-server-2.3.0.tgz"
  sha256 "45d6d3ddf354d281b050bb2a41faed840c0996b03705d04169787b4f91f96221"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/vim-language-server-2.3.0"
    sha256 cellar: :any_skip_relocation, monterey:     "232957da5e023eb4e9027313fd976526b3f733caf7fc3d421ff214914e682460"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca9072ce549a70abc58d18bd97b57a9f8c1f42f11c8eed04e513dffe22c99c2b"
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
