class BothubMcp < Formula
  desc "MCP server for BotHub: image and music generation with local preparation and explicit paid execution"
  homepage "https://gitlab.com/thepax/bothub-mcp"
  version "1.15.1"
  license "AGPL-3.0-only"

  # Releases publish prebuilt archives to GitLab's generic package registry:
  # darwin/arm64 and linux/arm64 tar.gz, checksums in the release's
  # SHA256SUMS.txt. Platforms without a prebuilt archive — Intel macs,
  # amd64 linux — fall back to building the release tag from source.
  if OS.mac? && Hardware::CPU.arm?
    url "https://gitlab.com/api/v4/projects/thepax%2Fbothub-mcp/packages/generic/bothub-mcp/v#{version}/bothub-mcp-v#{version}-darwin-arm64.tar.gz"
    sha256 "97abfa77c0ca553698b0841714da5db4786f6bfc4723a8d1f325438974666898"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://gitlab.com/api/v4/projects/thepax%2Fbothub-mcp/packages/generic/bothub-mcp/v#{version}/bothub-mcp-v#{version}-linux-arm64.tar.gz"
    sha256 "ec66b5d06d1b63fecff148d0d25d3d5cac454e1841b2b80007256885bc3bb911"
  else
    url "https://gitlab.com/thepax/bothub-mcp/-/archive/v#{version}/bothub-mcp-v#{version}.tar.gz"
    sha256 "8e0d779a63b17b672467e21288e4787120779c6d836bd5a9779cee5312a8c14b"
    depends_on "go" => :build
  end

  # GitLab's anonymous API and web feeds are aggressively rate-limited
  # (HTTP 429), so version discovery goes through plain git: ls-remote on
  # tags is exempt from the API throttle.
  livecheck do
    url "https://gitlab.com/thepax/bothub-mcp.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git
  end

  def install
    # Prebuilt archives carry the binary named bothub-mcp-v<version>-<os>-arm64
    # at the archive root; the source tarball has no such file.
    prebuilt = Dir["bothub-mcp-v#{version}-*"].find { |f| File.file?(f) && File.executable?(f) }
    if prebuilt
      bin.install prebuilt => "bothub-mcp"
    else
      system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/bothub-mcp"
    end
  end

  test do
    # BOTHUB_MCP_KEY is validated first, so provide one to reach the
    # BOTHUB_MCP_STORAGE_DIR check.
    ENV.delete("BOTHUB_MCP_STORAGE_DIR")
    ENV["BOTHUB_MCP_KEY"] = "test-key"
    assert_match "BOTHUB_MCP_STORAGE_DIR is required",
      shell_output("#{bin}/bothub-mcp 2>&1", 1)
  end
end
