require "language/node"

class DockerfileLanguageServer < Formula
  desc "Language server for Dockerfiles"
  homepage "https://github.com/rcjsuen/dockerfile-language-server-nodejs"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.9.0.tgz"
  sha256 "88a6085ca049ebdf383f3644ee699e982379e3767918bf14baedd0ef90c1e18f"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/dockerfile-language-server-0.9.0"
    sha256 cellar: :any_skip_relocation, monterey:     "66e0006b1d5a58ae5b1a6163be9d320366b9eb67b33d9902c868ddd37ee951d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0cbf19af71c82815dca21168f329cca6ed9dad1f1266184716dcc57780508aae"
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

    Open3.popen3("#{bin}/docker-langserver", "--stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
