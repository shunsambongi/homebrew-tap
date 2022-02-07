class BleSh < Formula
  desc "Bash Line Editor"
  homepage "https://github.com/akinomyoga/ble.sh"
  url "https://github.com/akinomyoga/ble.sh/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3d4302e8340e86a257a354898cd4b3493b0a658baf14e14e249077288e207c90"
  license "BSD-3-Clause"
  head "https://github.com/akinomyoga/ble.sh.git", branch: "master"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/ble.sh-0.3.3"
    sha256 cellar: :any_skip_relocation, big_sur:      "e131f044dbdeafb01a0fc705ad3c685860d74df85186adcabbf0f44afd517f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3a978363b4a03a71a3bff87b6d4f93abf25e0889aa4b5a73833a0405c61af7f0"
  end

  depends_on "gawk" => :build
  depends_on "make" => :build
  depends_on "bash"

  def install
    if build.head?
      system "make", "install", "PREFIX=#{prefix}"
    else
      system "make", "INSDIR=#{share}/blesh", "install"
    end
  end

  def caveats
    <<~EOS
      To load ble.sh, run the following in any interactive bash session:
        source #{HOMEBREW_PREFIX}/share/blesh/ble.sh

      Or automatically load ble.sh by adding these lines to .bashrc:
        # Add this line at the top of .bashrc:
        [[ $- == *i* ]] && source #{HOMEBREW_PREFIX}/share/blesh/ble.sh --noattach

        # Add this line at the end of .bashrc:
        [[ ${BLE_VERSION-} ]] && ble-attach
    EOS
  end

  test do
    require "open3"
    _, stderr = Open3.capture3("bash", "-c", "source #{HOMEBREW_PREFIX}/share/blesh/ble.sh")
    assert_match "This is not an interactive session", stderr
  end
end
