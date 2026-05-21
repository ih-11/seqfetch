# PacBio

PacBio long-read sequencing workflows, metadata organization, and operational notes for `seqfetch`.

This module currently uses *Chlamydomonas reinhardtii* transcriptomic long-read datasets as a working example for large-scale PacBio SRA handling, extraction, compression, and metadata tracking.

---

## Module Structure

```text
pacbio/
├── README.md
├── accessions/
├── metadata/
└── qc/
```

---

## Current Datasets

| Run         | Organism                  | Description                             |
| ----------- | ------------------------- | --------------------------------------- |
| SRR12885578 | Chlamydomonas reinhardtii | PacBio transcriptomic long-read dataset |
| SRR12880040 | Chlamydomonas reinhardtii | PacBio transcriptomic long-read dataset |

------

## SRA Accession Hierarchy

NCBI SRA datasets follow a hierarchical structure:

```
BioProject
└── BioSample
    └── Experiment (SRX)
        └── Run (SRR)
```

Example:

```
PRJNA670202
└── SAMN16533637
    └── SRX9351321
        └── SRR12885578
```

`seqfetch` primarily tracks sequencing runs at the SRR level while preserving accession relationships in YAML metadata files.

------

## PacBio Long-Read Notes

PacBio accessions may:

- use BAM-based archival structures
- contain aligned schemas
- produce extremely large FASTQ outputs
- require substantial temporary extraction storage
- behave differently from standard Illumina short-read accessions

SRA archival structure does NOT necessarily mean raw reads are unavailable.

In many cases, FASTQ extraction can still be performed successfully using SRA Toolkit.

Always inspect accession information before downloading large datasets.

------

## Inspect Accession Information Before Download

Before downloading large datasets, inspect:

- sequencing platform
- file size
- storage format
- schema information
- archive organization

Example:

```
vdb-dump --info SRRXXXXXXX
```

Example output may include:

- PacBio platform information
- BAM/SRA archival structure
- estimated archive size
- alignment schema information

This step is especially important for long-read sequencing datasets.

------

## Environment Setup

Create the conda environment:

```
conda env create -f ../envs/sra.yml
conda activate sra
```

------

## Download SRA Accessions

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

## Raw Data Storage

Large sequencing datasets are stored outside the repository to avoid bloating the codebase.

Example local staging locations:

```
/mnt/d/Ibnu/Lab Stay/SRR12885578
/mnt/d/Ibnu/Lab Stay/SRR12880040
```

------

## Metadata Tracking

Each sequencing run is tracked using accession-centered YAML metadata files:

```
metadata/
├── SRR12885578.yaml
├── SRR12880040.yaml
└── ...
```

Metadata files may contain:

- accession hierarchy
- sequencing platform information
- dataset size and archive information
- local/server storage paths
- transfer status
- FASTQ extraction status
- preprocessing state
- downstream analysis notes

This design allows flexible long-read dataset tracking while preserving operational reproducibility.

------

## Validate Downloaded SRA Object

After download:

```
vdb-validate /path/to/SRRXXXXXXX
```

Validation helps detect:

- corrupted downloads
- incomplete archives
- schema inconsistencies

------

## Test FASTQ Extraction

Before running full extraction for large datasets:

```
fastq-dump --stdout -X 2 SRRXXXXXXX | head
```

If extraction works correctly, FASTQ reads should appear in terminal output.

This small test is highly recommended before launching multi-hour extraction jobs.

------

## Convert SRA to FASTQ

Example:

```
fasterq-dump \
SRRXXXXXXX \
-O output_dir \
-e 8 \
-p
```

Parameters:

- ```
  -e
  ```

  - number of worker threads

- ```
  -p
  ```

  - progress display

PacBio FASTQ extraction may require:

- many hours
- large temporary storage
- significant I/O bandwidth

------

## Storage Caution

`fasterq-dump` may require substantially more temporary storage than the final FASTQ size.

Example:

- 60 GB SRA archive

- > 150 GB temporary extraction usage

- > 500 GB uncompressed FASTQ output

Always inspect available storage before extraction:

```
df -h
```

------

## Monitor Active Extraction

Monitor extraction progress:

```
htop
```

or:

```
ps aux | grep fasterq
```

Check output size growth:

```
watch -n 30 'ls -lh output_dir'
```

------

## Server-Side Long-Read Workflow

Large PacBio datasets are typically transferred to a dedicated analysis server before full FASTQ extraction.

Example organization:

```
/mnt/data1/chlamydomonas_pacbio/
├── SRR12880040/
│   ├── raw_sra/
│   └── fastq/
└── SRR12885578/
    ├── raw_sra/
    └── fastq/
```

Recommended separation:

### `raw_sra/`

Immutable archived SRA objects.

### `fastq/`

Contains:

- extracted FASTQ files
- compressed FASTQ outputs
- downstream preprocessing outputs

This separation helps preserve original archives while organizing derived files cleanly.

------

## Safe Compression for Large FASTQ Files

PacBio FASTQ files may reach hundreds of gigabytes uncompressed.

For remote servers, background compression is strongly recommended:

```
nohup gzip sample.fastq > gzip.log 2>&1 &
```

This allows compression to continue safely even if the SSH session disconnects.

Monitor compression progress:

```
ps aux | grep gzip
```

and:

```
ls -lh
```

------

## Monitor Download Size

Check active storage usage:

```
du -sh "/mnt/d/Ibnu/Lab Stay/SRR12885578"
du -sh "/mnt/d/Ibnu/Lab Stay/SRR12880040"
```

Continuous monitoring:

```
watch -n 5 'du -sh .'
```

------

## Example Workflow

```
1. Inspect accession metadata
2. Create curated YAML metadata
3. Download SRA archive
4. Validate archive
5. Test FASTQ extraction
6. Transfer to analysis server
7. Run full FASTQ extraction
8. Compress FASTQ outputs
9. Update metadata and QC status
10. Prepare downstream analysis
```

------

## Troubleshooting Notes

### SSH disconnect during compression

Problem:

```
Connection timed out
Broken pipe
```

Solution:

```
nohup gzip sample.fastq > gzip.log 2>&1 &
```

------

### FASTQ extraction appears stalled

Possible causes:

- insufficient storage
- temporary extraction bottleneck
- heavy server I/O usage

Monitor:

```
htop
df -h
```

------

### Large FASTQ outputs

PacBio transcriptomic datasets may produce:

- hundreds of gigabytes of FASTQ
- very long compression times
- high storage pressure

Always plan storage conservatively.

------

## Future Development

Planned additions include:

- Iso-Seq-specific workflows
- CCS/subread handling
- automated metadata extraction
- FASTQ statistics integration
- BAM inspection utilities
- alignment preparation workflows
- long-read QC integration