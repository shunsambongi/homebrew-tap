class Dotter < Formula
  desc "Dotfile manager and templater written in rust 🦀"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/v0.12.7.tar.gz"
  sha256 "4a6f24179a6a9495226456ed89eb770e650bee26e3f6e729bd37aaa97cd1efbd"
  license "Unlicense"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/dotter-0.12.7"
    sha256 cellar: :any_skip_relocation, big_sur:      "f76ce45ebb6dc81f89a55cdb8e5f49c9a713cb081289cb22099f747d457005ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0224d1cc54265a3ccfd74e9d300dc4c784cc27f39d3e71fd9476aa2482921b28"
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
