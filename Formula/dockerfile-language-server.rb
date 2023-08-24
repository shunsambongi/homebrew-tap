require "language/node"

class DockerfileLanguageServer < Formula
  desc "Language server for Dockerfiles"
  homepage "https://github.com/rcjsuen/dockerfile-language-server-nodejs"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.9.0.tgz"
  sha256 "88a6085ca049ebdf383f3644ee699e982379e3767918bf14baedd0ef90c1e18f"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/dockerfile-language-server-nodejs-0.9.0"
    sha256 cellar: :any_skip_relocation, monterey:     "30263d48331a33fa8b3e4fa9def410946d0f36d21dadadbc22678324c81131c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3dba82ad0e5823839c5e2f5c8e32f8f06da67f2710c5cc0d937ebd54fd9e7713"
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
