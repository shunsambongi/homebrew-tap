class Pistol < Formula
  desc "General purpose file previewer"
  homepage "https://github.com/doronbehar/pistol"
  url "https://github.com/doronbehar/pistol/archive/v0.3.2.tar.gz"
  sha256 "7eaf196bbf9f8aaa78a9688ee8c13dbd5c91050e470526e052256a2dd35988d0"
  license "MIT"
  head "https://github.com/doronbehar/pistol.git", branch: "master"

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
