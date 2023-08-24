class Lemonade < Formula
  desc "Copy, paste and open browser over TCP"
  homepage "https://github.com/lemonade-command/lemonade"
  url "https://github.com/lemonade-command/lemonade/archive/v1.1.2.tar.gz"
  sha256 "d1161db5e2273f9529369f7f2c14a870fe68fa8763737df38f80f92295c3c667"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/lemonade", "--help"
  end
end
