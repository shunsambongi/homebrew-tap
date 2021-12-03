class TaploCli < Formula
  desc "Taplo TOML Utility"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-cli-0.4.1.tar.gz"
  sha256 "40af2db2fe2a17b2518840c157d59a065d3ea27e0c6000919048ad31f40e919c"
  license "MIT"

  livecheck do
    url :stable
    regex(/release-cli-(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build
  on_linux do
    depends_on "pkg-config" => :build
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
