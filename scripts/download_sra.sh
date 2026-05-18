#!/bin/bash
set -euo pipefail

ACCESSION=$1
OUTDIR=$2
THREADS=${3:-8}
MAX_SIZE=${4:-100G}

mkdir -p "$OUTDIR"

echo "Downloading $ACCESSION ..."
prefetch "$ACCESSION" --max-size "$MAX_SIZE"

echo "Validating $ACCESSION ..."
vdb-validate "$ACCESSION"

echo "Testing FASTQ extraction ..."
fastq-dump --stdout -X 2 "$ACCESSION" | head

echo "Converting to FASTQ ..."
fasterq-dump "$ACCESSION" \
  -O "$OUTDIR" \
  -e "$THREADS"

echo "Compressing FASTQ ..."
gzip "$OUTDIR"/${ACCESSION}*.fastq

echo "Done: $ACCESSION"