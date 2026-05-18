# seqfetch

Utility repository for downloading, organizing, tracking, and managing public sequencing datasets and metadata from NCBI Sequence Read Archive (SRA).

---

## Features

- Download sequencing datasets from NCBI SRA
- Extract FASTQ reads using SRA Toolkit
- Curated YAML-based metadata tracking
- Track accession hierarchy and local storage paths
- Reproducible conda environment setup
- Organize accession information and sequencing metadata
- Reusable workflow for Illumina, PacBio, Nanopore, and other sequencing platforms

---

## Repository Structure

```text
seqfetch/
├── accessions/   accession IDs, run information, and master tables
├── metadata/     curated YAML metadata for sequencing runs
├── scripts/      reusable download and processing scripts
├── envs/         conda environment files
├── docs/         additional documentation and logs
└── qc/           quality control outputs
```

## SRA Accession Hierarchy

NCBI SRA datasets follow a hierarchical structure:

```text
BioProject
└── BioSample
    └── Experiment (SRX)
        └── Run (SRR)
```

Example:

```text
PRJNA670202
└── SAMN16533637
    └── SRX9351321
        └── SRR12885578
```

`seqfetch` primarily tracks sequencing runs at the SRR level while preserving accession relationships in YAML metadata files.

## Environment Setup

Create the conda environment:

```
conda env create -f envs/sra.yml
conda activate sra
```

---

## Inspect Accession Information Before Download

Before downloading large datasets, inspect:

- sequencing platform
- file size
- storage format
- schema information

```
vdb-dump --info SRRXXXXXXX
```

Example output may include:

- platform type (Illumina, PacBio, Nanopore)
- estimated size
- BAM/SRA archival structure
- alignment schema information

This step is especially important for large long-read datasets.

---

## Download SRA Accession

Example:

```
prefetch SRRXXXXXXX
```

Large datasets may trigger:

```
Maximum file size download limit is 20GB
```

Increase the limit manually:

```
prefetch SRRXXXXXXX --max-size 100G
```

For very large datasets:

```
prefetch SRRXXXXXXX --max-size 500G
```

---

## Raw Data Storage

Large sequencing datasets are stored outside the repository to avoid bloating the codebase.

Example storage locations:

```text
/mnt/d/Ibnu/Lab Stay/SRR12885578
/mnt/d/Ibnu/Lab Stay/SRR12880040
```

Metadata files inside `metadata/*.yaml` track:

- accession relationships
- sequencing information
- download status
- local storage paths
- preprocessing state

---

## Validate Downloaded SRA Object

After download:

```
vdb-validate /path/to/SRRXXXXXXX
```

---

## Test FASTQ Extraction

Before running full conversion for large datasets:

```
fastq-dump --stdout -X 2 SRRXXXXXXX | head
```

If FASTQ extraction works correctly, reads should appear in terminal output.

---

## Convert SRA to FASTQ

```
fasterq-dump \
SRRXXXXXXX \
-O output_dir \
-e 8
```

---

## Compress FASTQ Files

```
gzip output_dir/*.fastq
```

---

## Example Script Usage

```
./scripts/download_sra.sh \
SRRXXXXXXX \
"/path/to/output"
```
---

## Script Parameters

```bash
./scripts/download_sra.sh ACCESSION OUTDIR [THREADS] [MAX_SIZE]
```

---

## Storage Caution

`fasterq-dump` may require substantially more temporary storage than the final FASTQ size.

Example:

- 60 GB SRA
- may temporarily require >150 GB during conversion

Check available storage before conversion:

```
df -h
```

---

## Monitor Download Size

Check current download size during active downloads:

```bash
du -sh "/mnt/d/Ibnu/Lab Stay/SRR12885578"
du -sh "/mnt/d/Ibnu/Lab Stay/SRR12880040"
```

For continuous monitoring:

```bash
watch -n 5 'du -sh .'
```

---

## Long-Read Dataset Notes

PacBio and Nanopore accessions may:

- use BAM-based archival structures
- contain aligned schemas
- or package raw reads differently from Illumina datasets

SRA archival format does not necessarily indicate whether raw reads are unavailable. In many cases, FASTQ reads can still be extracted successfully using SRA Toolkit.

Always inspect accession metadata before large downloads.

---

## Recommended Workflow

```
1. Inspect accession metadata
2. Create curated YAML metadata
3. Download SRA object
4. Validate download
5. Test FASTQ extraction
6. Run full FASTQ conversion
7. Compress FASTQ files
8. Update metadata and QC status
```
## Future Development

Planned improvements include:

- specialized docs (e.g illumina, nanopore, scRNA-seq, Ribo-seq)
- automated metadata extraction from SRA/ENA
- QC report integration
- adapter detection tracking
- automatic accession hierarchy parsing
- workflow automation for large-scale dataset management