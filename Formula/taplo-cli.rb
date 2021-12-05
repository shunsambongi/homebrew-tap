class TaploCli < Formula
  desc "Taplo TOML Utility"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-cli-0.5.0.tar.gz"
  sha256 "65c5223cb5bd5a6d40200ca72f55b120675292accf0a0d9a9eb8d11ebdcb57ae"
  license "MIT"

  livecheck do
    url :stable
    regex(/release-cli-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/taplo-cli-0.5.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "4d341bfe821ef58463344d6eb233fb7d5f157b61b1c1001b37f0241d04f16035"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "65d3c77235fa0661361e00c1790c01efe1099c881591ecc47432d4f89df28e3d"
  end

  depends_on "rust" => :build
  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "taplo-cli")
  end

  test do
    testfile = testpath/"test.toml"

    testfile.write <<~EOS
      [test]
        test = "test"
    EOS

    output = <<~EOS
      [test]
      test = "test"
    EOS

    system "#{bin}/taplo", "format", testfile
    assert_equal output.chomp, testfile.read.chomp
  end
end
