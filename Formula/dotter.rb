class Dotter < Formula
  desc "Dotfile manager and templater written in rust"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/v0.13.0.tar.gz"
  sha256 "5dee1b157e0a67b0a5c925777c83ece98676a7ed145d5c4436e4ada6d6ae5254"
  license "Unlicense"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/dotter-0.13.0"
    sha256 cellar: :any_skip_relocation, monterey:     "47f20ea27e2c9f3e58f28db5cef2137d183d0800bfe2f70c2ab9354f0b2754d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1cb77eae4c0d54538b20770a4b0846425c152116b82ad1b1c2211806e955192a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir ".dotter"
    (testpath/"source.txt").write("Hello World from Dotter!")
    (testpath/".dotter/global.toml").write("[test.files]\n'source.txt' = 'target.txt'")
    (testpath/".dotter/local.toml").write("packages = ['test']")
    system "#{bin}/dotter", "--quiet"
    assert_equal "Hello World from Dotter!", (testpath/"target.txt").read.chomp
  end
end
