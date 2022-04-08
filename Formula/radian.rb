class Radian < Formula
  include Language::Python::Virtualenv

  desc "21 century R console"
  homepage "https://github.com/randy3k/radian"
  url "https://files.pythonhosted.org/packages/a2/21/58fa19a55b60b3bf2d2281a221e268d3401cc00b2530ba6292a32f48e959/radian-0.6.0.tar.gz"
  sha256 "a3b522f553205202a182d524af493ce43e8840d91a306a8ea074054cf2a3648d"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/radian-0.5.13"
    sha256 cellar: :any,                 big_sur:      "b9fe65e5fc8d6d1ba22e1dadae1ef71f04d414962c69f46b2461987a218b70c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dc861f1c89f5ff30e6be41355cadc41cb257ba5ac67b6678ccac25a46a89e572"
  end

  depends_on "python"
  depends_on "r"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "rchitect" do
    url "https://files.pythonhosted.org/packages/6e/62/d7f35b3a9dfddda7f49a44a02135660c1031f95783d8f94437fccf2c85d7/rchitect-0.3.36.tar.gz"
    sha256 "29dc7de687e6bb5823523d4170086cdf0aabb374a2807cf01873285b3897da4a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "radian", "--version"
  end
end
