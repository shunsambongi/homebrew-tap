class Pistol < Formula
  desc "General purpose file previewer"
  homepage "https://github.com/doronbehar/pistol"
  url "https://github.com/doronbehar/pistol/archive/v0.4.2.tar.gz"
  sha256 "559607de2904b7a45456eeabb6d60f2586fa50168f3974ec24f8b341dd8458de"
  license "MIT"
  head "https://github.com/doronbehar/pistol.git", branch: "master"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/pistol-0.4.2"
    sha256 cellar: :any,                 monterey:     "3cf730837dd361286bdb2da07096f5114526c2593066449be6db2735f7dd1e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b42dc7a2dcbf4ff2c5c90b8f011e471fdf3a2ac8db1343dca6914da3afafe8f7"
  end

  depends_on "go" => :build
  depends_on "libmagic"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/pistol"
  end

  test do
    (testpath/"test.txt").write("test")
    assert_equal "test", shell_output("#{bin}/pistol test.txt").strip
  end
end
