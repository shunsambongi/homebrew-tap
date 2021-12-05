class TaploLsp < Formula
  desc "Language server for Taplo"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-lsp-0.2.6.tar.gz"
  sha256 "594f7d490294bd014ba1ce2cdba0a2b1ec39155c93ca7b593d045fa63b74a13a"
  license "MIT"

  livecheck do
    url :stable
    regex(/release-lsp-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/taplo-lsp-0.2.6"
    sha256 cellar: :any_skip_relocation, big_sur:      "f74bbd6d2676ea4b62ff111cf286a93f5c30e81001fdd390b20ee90d8ebd5d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19eb948c8b2f0bd35d6a24c952b408bc26e066eee4bdee57e72ba4b1f311eb97"
  end

  depends_on "rust" => :build
  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "taplo-lsp")
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n\r\n#{json}"
    end

    require "open3"
    Open3.popen3("#{bin}/taplo-lsp", "run") do |stdin, stdout, _|
      # sleep 1
      message = rpc <<~EOF
        {
          "jsonrpc":"2.0",
          "id":1,
          "method":"initialize",
          "params":{
            "capabilities":{}
          }
        }
      EOF

      stdin.write message
      sleep 1
      stdin.close

      output = stdout.read
      expected = /Content-Length: \d+\r\n\r\n/
      puts output

      assert_match expected, output
    end
  end
end
