class Radian < Formula
  include Language::Python::Virtualenv

  desc "21 century R console"
  homepage "https://github.com/randy3k/radian"
  url "https://files.pythonhosted.org/packages/8f/1e/708089897863a6d5c8ab56d18e4577576c3bc75a9b4d068f7ee6e65afe66/radian-0.6.4.tar.gz"
  sha256 "4524a10335a6464a423a58ab85544fb37ebb9973cd647b00cc4eb40637bdf40c"
  license "MIT"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/radian-0.6.4"
    sha256 cellar: :any_skip_relocation, monterey:     "5fc12f009680e158dfc6aa12ccf55ecc82a58ef0804e12dcc8b88fa11a390c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "838f0adf7b9f1af84bc3ac578c207a90c79e9fac97da813bcc8e24ce73a52d0f"
  end

  depends_on "python"
  depends_on "r"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "rchitect" do
    url "https://files.pythonhosted.org/packages/d0/39/0b6c2ca15c8d83000b661abdb53b1ee3f6138416eda2dfdb4e0e872339c1/rchitect-0.3.40.tar.gz"
    sha256 "1c5de5c4914dcb34225e7b62dbfc5df7b857b0b4bc18d4adf03611c45847b8b7"
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
