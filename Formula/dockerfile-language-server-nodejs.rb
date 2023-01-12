require "language/node"

class DockerfileLanguageServerNodejs < Formula
  desc "Language server for Dockerfiles"
  homepage "https://github.com/rcjsuen/dockerfile-language-server-nodejs"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.9.0.tgz"
  sha256 "88a6085ca049ebdf383f3644ee699e982379e3767918bf14baedd0ef90c1e18f"
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
