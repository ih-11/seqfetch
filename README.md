# seqfetch

Utility repository for downloading, organizing, and managing public sequencing datasets from NCBI Sequence Read Archive (SRA).

---

## Features

- Download sequencing datasets from NCBI SRA
- Extract FASTQ reads using SRA Toolkit
- Reproducible conda environment setup
- Organize accession information and metadata
- Reusable workflow for Illumina, PacBio, Nanopore, and other sequencing platforms

---

## Repository Structure

```text
seqfetch/
├── accessions/   accession IDs and run information
├── metadata/     sample metadata tables
├── scripts/      reusable download scripts
├── envs/         conda environment files
└── docs/         additional documentation


