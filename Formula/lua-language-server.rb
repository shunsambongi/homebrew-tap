# Based on a combination of:
# - https://github.com/laggardkernel/homebrew-tap/blob/master/Formula/lua-language-server.rb
# - https://github.com/saadparwaiz1/homebrew-personal/blob/main/Formula/lua-language-server.rb
class LuaLanguageServer < Formula
  desc "Language Server for Lua"
  homepage "https://github.com/sumneko/lua-language-server"
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.5.2",
      revision: "cb2042160865589b5534a6bf0b6c366ae4ab1d99"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    root_url "https://github.com/shunsambongi/homebrew-tap/releases/download/lua-language-server-2.5.1"
    sha256 cellar: :any_skip_relocation, big_sur:      "13cb5c67cf5eda206efa7e31e5875cd51e6f18c07645061fa5c8c0e4f2188cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f329f26fcdc0a7f4b6bb67b1c99e3b23adfac3b60903bfa7ce23c0e2f647bf9b"
  end

  depends_on "ninja" => :build

  def install
    if OS.mac?
      # Disable test that circumvents Homebrew's sandboxed environment.
      # (NSSearchPathForDirectoriesInDomains doesn't respect $HOME set by build environment)
      [buildpath.to_s, "#{buildpath}/3rd/luamake"].each do |dir|
        inreplace "#{dir}/3rd/bee.lua/test/test_filesystem.lua" do |s|
          s.gsub! "function test_fs:test_appdata_path()", "function appdata_path()"
        end
      end

      platform = "macOS"
    elsif OS.linux?
      platform = "Linux"
    else
      odie "Unsupported platform."
    end

    cd "#{buildpath}/3rd/luamake" do
      # Don't use ./compile/install.sh because it modifies shell startup files
      system "ninja", "-f", "compile/ninja/#{platform.downcase}.ninja"
    end
    system "#{buildpath}/3rd/luamake/luamake", "rebuild"

    prefix.install "locale"
    prefix.install "meta"
    prefix.install "script"
    prefix.install "main.lua"
    prefix.install "debugger.lua"
    libexec.install "bin/#{platform}" => "bin"
    bin.write_exec_script "#{libexec}/bin/lua-language-server"
  end

  test do
    output = shell_output("#{bin}/lua-language-server -e 'print(1 + 1)'").chomp
    assert_equal "2", output
    # def rpc(json)
    #   "Content-Length: #{json.size}\r\n\r\n#{json}"
    # end

    # require "open3"
    # Open3.popen3("#{bin}/lua-language-server") do |stdin, stdout, _|
    #   sleep 1
    #   message = rpc <<~EOF
    #     {
    #       "jsonrpc":"2.0",
    #       "id":1,
    #       "method":"initialize",
    #       "params":{
    #         "capabilities":{}
    #       }
    #     }
    #   EOF
    #
    #   stdin.write message
    #   sleep 1
    #   stdin.close
    #
    #   output = stdout.read
    #   expected = /Content-Length: \d+\r\n\r\n/
    #   puts output
    #
    #   assert_match expected, output
    # end
  end
end
