class BothubMcp < Formula
  desc "MCP server for BotHub: image and music generation with local preparation and explicit paid execution"
  homepage "https://gitlab.com/thepax/bothub-mcp"
  version "1.17.0"
  license "AGPL-3.0-only"

  # Releases publish prebuilt archives with permanent download links:
  # darwin/arm64 and linux/arm64 tar.gz, checksums in the release's
  # SHA256SUMS.txt. Platforms without a prebuilt archive — Intel macs,
  # amd64 linux — fall back to building the release tag from source.
  if OS.mac? && Hardware::CPU.arm?
    url "https://gitlab.com/thepax/bothub-mcp/-/releases/v#{version}/downloads/bothub-mcp-v#{version}-darwin-arm64.tar.gz"
    sha256 "f67e5bba310957184991c554cadaa68be6b19722eb3efb093b9f65124af7c421"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://gitlab.com/thepax/bothub-mcp/-/releases/v#{version}/downloads/bothub-mcp-v#{version}-linux-arm64.tar.gz"
    sha256 "b20edb9d01c2f6028f19df7499fb4f67a85c394de1d04da77388d0b04d1a21a3"
  else
    url "https://gitlab.com/thepax/bothub-mcp/-/archive/v#{version}/bothub-mcp-v#{version}.tar.gz"
    sha256 "1e29ccb0b3d317f38ad0cde1fc654b62db1e01df228d55f568bcbb38713b580c"
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
    # --version answers before any environment configuration is read.
    assert_equal version, shell_output("#{bin}/bothub-mcp --version").strip
  end
end
