class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.44.2",
      revision: "e50a6dc4b43e2183e245aded8d23f0003d8c6bf7"
  license "MIT"

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n\r\n#{json}"
    end

    require "open3"
    Open3.popen3("#{bin}/solargraph", "stdio") do |stdin, stdout, _|
      message = rpc <<~EOF
        {
          "jsonrpc": "2.0",
          "id": 1,
          "method": "initialize",
          "params": {}
        }
      EOF

      stdin.write message
      sleep 1
      stdin.close

      output = /Content-Length: \d+\r\n\r\n/
      assert_match output, stdout.read
    end
  end
end
