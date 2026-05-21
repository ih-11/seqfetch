# seqfetch

Utility repository for downloading, organizing, tracking, and managing public sequencing datasets and metadata.

## Purpose

`seqfetch` is organized as a modular sequencing-data management repository. Each sequencing technology has its own accession records, metadata files, QC outputs, and workflow notes.

## Repository Structure

```text
seqfetch/
├── pacbio/      PacBio long-read datasets
├── illumina/    Illumina short-read datasets
├── nanopore/    Oxford Nanopore datasets
├── riboseq/     Ribo-seq datasets
├── docs/        general workflow notes
├── envs/        conda environment files
└── scripts/     reusable helper scripts
```

## Technology Modules

Each sequencing type follows the same internal structure:

```
technology/
├── README.md
├── accessions/
├── metadata/
└── qc/
```

## Metadata Philosophy

Each dataset is tracked with accession-centered YAML metadata.

Metadata may include:

- accession hierarchy
- organism and experiment information
- sequencing platform
- file size and archive format
- local/server storage paths
- FASTQ extraction status
- preprocessing status
- notes for downstream analysis

## Current Modules

| Module      | Status                                                       |
| ----------- | ------------------------------------------------------------ |
| `pacbio/`   | active example using Chlamydomonas PacBio long-read RNA data |
| `illumina/` | placeholder                                                  |
| `nanopore/` | placeholder                                                  |
| `riboseq/`  | placeholder                                                  |

## General Workflow

```
1. Inspect accession metadata
```

Only accession records, metadata, scripts, documentation, and QC summaries are tracked.