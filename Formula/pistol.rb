class Pistol < Formula
  desc "General purpose file previewer"
  homepage "https://github.com/doronbehar/pistol"
  url "https://github.com/doronbehar/pistol/archive/v0.3.2.tar.gz"
  sha256 "7eaf196bbf9f8aaa78a9688ee8c13dbd5c91050e470526e052256a2dd35988d0"
  license "MIT"
  head "https://github.com/doronbehar/pistol.git", branch: "master"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/pistol-0.3.2"
    sha256 cellar: :any,                 big_sur:      "a66849c17dd640dd70dd5743256f1aa146a098d3992cb7c0244c2013cfd94343"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd724fe5764c70c66c74dbca1b784ccb77a27f5efc749d8f85072f81049f0e6c"
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
