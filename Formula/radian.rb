class Radian < Formula
  include Language::Python::Virtualenv

  desc "21 century R console"
  homepage "https://github.com/randy3k/radian"
  url "https://files.pythonhosted.org/packages/f5/1b/56abbf044c8d07374af5842be86a83d2888daa38ba9c2bad1681b88ac892/radian-0.5.13.tar.gz"
  sha256 "d05701f4be8c01c53a0bedb0fa0822a14a4b1fff4b8980bfc11712b9319b261e"
  license "MIT"

  depends_on "python"
  depends_on "r"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "lineedit" do
    url "https://files.pythonhosted.org/packages/9f/ea/dd0b274a44ae64e0688cf6da5a56df757f1b48aa6b358fd8b8aa838aa851/lineedit-0.1.6.tar.gz"
    sha256 "f4795479154e350ad9cf6e8be6ad3a78f10f892b99675af2f8140f2d847f6f3f"
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
    url "https://files.pythonhosted.org/packages/a5/20/b0e320ea5d92d04bbf3490254b8579ff44a5fc7af915d58443b7cf620f62/rchitect-0.3.35.tar.gz"
    sha256 "bd652e14041d9371158ef9f4362af096d7bbe2d44593a9dab2bb0d58ff3db4ae"
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
