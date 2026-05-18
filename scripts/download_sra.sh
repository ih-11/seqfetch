#!/bin/bash

ACCESSION=$1
OUTDIR=$2
THREADS=${3:-8}

mkdir -p "$OUTDIR"

echo "Downloading $ACCESSION ..."

prefetch "$ACCESSION"

echo "Converting to FASTQ ..."

fasterq-dump ~/ncbi/public/sra/${ACCESSION}.sra \
-O "$OUTDIR" \
-e "$THREADS"

echo "Compressing FASTQ ..."

gzip "$OUTDIR"/${ACCESSION}*.fastq

echo "Done: $ACCESSION"
