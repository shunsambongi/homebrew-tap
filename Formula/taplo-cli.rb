class TaploCli < Formula
  desc "Taplo TOML Utility"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-cli-0.6.1.tar.gz"
  sha256 "8ef4daebb71931c6516322d2cbb452eadf470d74413b30f8f4e986bb87ea8187"
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
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/taplo-cli")
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
