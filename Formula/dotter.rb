class Dotter < Formula
  desc "Dotfile manager and templater written in rust 🦀"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/v0.12.14.tar.gz"
  sha256 "1fdb77ec4699878e4f5492e04fbb9eada53f0ecddfa693a2918a5fd01350c64b"
  license "Unlicense"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/dotter-0.12.14"
    sha256 cellar: :any_skip_relocation, monterey:     "e63399d72b693a33c91dcc54ab0075610f248abc1142b292694783526f1c4b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b30d35d8eba6e9c919a120a76707c85a43712ba63349cf85caf8973fe7d4a089"
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
