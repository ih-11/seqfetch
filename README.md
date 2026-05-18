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
```

## Environment Setup

Create the conda environment:

```
conda env create -f envs/sra.yml
conda activate sra
```

------

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

------

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

------

## Validate Downloaded SRA Object

After download:

```
vdb-validate ~/ncbi/public/sra/SRRXXXXXXX.sra
```

------

## Test FASTQ Extraction

Before running full conversion for large datasets:

```
fastq-dump --stdout -X 2 \
~/ncbi/public/sra/SRRXXXXXXX.sra | head
```

If FASTQ extraction works correctly, reads should appear in terminal output.

------

## Convert SRA to FASTQ

```
fasterq-dump \
~/ncbi/public/sra/SRRXXXXXXX.sra \
-O output_dir \
-e 8
```

------

## Compress FASTQ Files

```
gzip output_dir/*.fastq
```

------

## Example Script Usage

```
./scripts/download_sra.sh \
SRRXXXXXXX \
"/path/to/output"
```

------

## Storage Caution

`fasterq-dump` may require substantially more temporary storage than the final FASTQ size.

Example:

- 60 GB SRA
- may temporarily require >150 GB during conversion

Check available storage before conversion:

```
df -h
```

------

## Long-Read Dataset Notes

PacBio and Nanopore accessions may:

- use BAM-based archival structures
- contain aligned schemas
- or package raw reads differently from Illumina datasets

SRA archival format does not necessarily indicate whether raw reads are unavailable. In many cases, FASTQ reads can still be extracted successfully using SRA Toolkit.

Always inspect accession metadata before large downloads.

------

## Recommended Workflow

```
1. Inspect accession metadata
2. Download SRA object
3. Validate download
4. Test FASTQ extraction
5. Run full FASTQ conversion
6. Compress FASTQ files
```