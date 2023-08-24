class Radian < Formula
  include Language::Python::Virtualenv

  desc "21 century R console"
  homepage "https://github.com/randy3k/radian"
  url "https://files.pythonhosted.org/packages/6e/d1/2d270f061754368f9c5802805c05f9273e632e0343e65f1ed1053a73892d/radian-0.6.7.tar.gz"
  sha256 "297fe1c6581e7e50a70ed06614a5eb41e67aa96319e6834188c351d970435134"
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
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/d6/f7/4d461ddf9c2bcd6a4d7b2b139267ca32a69439387cc1f02a924ff8883825/Pygments-2.16.1.tar.gz"
    sha256 "1daff0494820c69bc8941e407aa20f577374ee88364ee10a98fdbe0aece96e29"
  end

  resource "rchitect" do
    url "https://files.pythonhosted.org/packages/d5/5a/247229fca143273687f1fafc7a8ae9172f7e12d9381edb1d46519cf5957e/rchitect-0.4.1.tar.gz"
    sha256 "6b8860f7af62582eaf405882d23a08b8e923f0f4437a2cd53684871d24dc21c3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/radian", "--version"
  end
end
