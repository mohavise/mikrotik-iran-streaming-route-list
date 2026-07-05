#!/usr/bin/env bash
set -euo pipefail

# Compatibility wrapper after project rename/rebuild.
# Use scripts/build-iran-streaming.sh for the real generator.
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/build-iran-streaming.sh" "$@"
