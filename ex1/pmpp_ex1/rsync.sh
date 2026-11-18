#!/usr/bin/env bash
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REMOTE="lcluster"
DEST="/home/kurse/kurs00108/dn86jefa/pmpp_ex1/"

rsync -avz --delete \
    --exclude='.git' \
    --exclude='build' \
    --exclude='rsync.sh' \
    --exclude='.zed' \
    --exclude='.vscode' \
    "${SRC}/" "${REMOTE}:${DEST}"
