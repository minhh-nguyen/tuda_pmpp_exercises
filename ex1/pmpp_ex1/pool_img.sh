#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REMOTE="lcluster"
SRC="/home/kurse/kurs00108/dn86jefa/pmpp_ex1/out/"
DEST="${HERE}/out/"

mkdir -p "${DEST}"
rsync -avz --progress "${REMOTE}:${SRC}" "${DEST}"

rsync -avz "${REMOTE}:/home/kurse/kurs00108/dn86jefa/pmpp_ex1/ex1.*" "${HERE}/"
