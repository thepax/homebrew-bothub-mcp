class BothubMcp < Formula
  desc "MCP server for BotHub: image and music generation with local preparation and explicit paid execution"
  homepage "https://gitlab.com/thepax/bothub-mcp"
  url "https://gitlab.com/thepax/bothub-mcp/-/archive/v1.15.1/bothub-mcp-v1.15.1.tar.gz"
  sha256 "8e0d779a63b17b672467e21288e4787120779c6d836bd5a9779cee5312a8c14b"
  license "AGPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?tags\/v?(\d+(?:\.\d+)+)/i)
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/bothub-mcp"
  end

  test do
    assert_match "BOTHUB_MCP_STORAGE_DIR is required",
      shell_output("#{bin}/bothub-mcp 2>&1", 1)
  end
end
