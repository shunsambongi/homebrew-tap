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
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/taplo-cli-0.4.1"
    sha256 cellar: :any_skip_relocation, big_sur:      "a95d9e4715db78bfda59741dd455f43844910f845c6329109ea08ef71c07df11"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e5850a1e46a58062cee55be797390f6831c715cf3b7a74a2655e899f165a3d02"
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
