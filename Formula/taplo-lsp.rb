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
