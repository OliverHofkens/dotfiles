#!/bin/bash
#
# Imports purchased FLACs into the beets library as Opus and moves the FLAC
# masters to the convert `dest` (FlacArchive).
#
# `-k` is required: it keeps the converted file in the library and moves the
# original to `dest`. The `keep_new` config option is ignored by beets 2.5.1.
# The `format:flac` query only matches not-yet-converted albums, so re-running
# is safe and picks up anything a previous run left behind.

set -euo pipefail

[ $# -ge 1 ] || { echo "usage: $0 <album dir>..." >&2; exit 1; }

beet import "$@"
beet convert -a -k -y format:flac
