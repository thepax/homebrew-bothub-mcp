# homebrew-bothub-mcp

Homebrew tap for [bothub-mcp](https://gitlab.com/thepax/bothub-mcp) — a Go
MCP server for [BotHub](https://bothub.chat/): image and music generation
tools with local request preparation and explicit paid execution, plus
delegated music analysis and transcription. AGPL-3.0-only.

## Install

```sh
brew install thepax/bothub-mcp/bothub-mcp
```

Or in two steps:

```sh
brew tap thepax/bothub-mcp
brew install bothub-mcp
```

On Apple Silicon macs and arm64 Linux the formula installs the prebuilt
release archive from GitLab's package registry — no Go toolchain needed.
Everywhere else it builds from the release tag source with the Go toolchain
pulled by Homebrew.

## Configuration

The server does not read `.env` files or command-line arguments; it takes
its configuration from the environment of the MCP client that spawns it.
The required variables are `BOTHUB_MCP_KEY` (BotHub developer key),
`BOTHUB_MCP_STORAGE_DIR` (absolute storage directory) and
`BOTHUB_MCP_HTTP_PORT` (loopback web UI port); see the
[upstream README](https://gitlab.com/thepax/bothub-mcp#quick-start) for
the full list and the local/remote deployment modes.

Releases are published on the
[upstream releases page](https://gitlab.com/thepax/bothub-mcp/-/releases)
as per-platform archives with checksums; this formula installs them where
available and builds from the tag elsewhere.
