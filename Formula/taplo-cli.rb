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
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/taplo-cli-0.6.1"
    sha256 cellar: :any,                 big_sur:      "55f6f6f241fbf72cb8a94377a637ead0455f8e76c79f976d63b73d5309a4993b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7cc62f2b95c5960453801b272d47d5738e0dd8883eab030e71bd681a175e8505"
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
