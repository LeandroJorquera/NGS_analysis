#!/usr/bin/env bash

set -euo pipefail

# ===== Check MMseqs2 availability =====
if ! command -v mmseqs &> /dev/null; then
    echo "Error: mmseqs not found in PATH. Load module or install MMseqs2."
    exit 1
fi

# ===== Input / Output =====
INPUT_FASTA="/Users/leandro/Desktop/github/NGS-data/ORF2library1_260411/raw-data/afterCMV-E3.fastq"
DB_NAME="seqDB"
CLUSTER_DB="clusterDB"
OUTPUT_TSV="clusters.tsv"

# ===== Threads (auto-detect) =====
if command -v nproc &> /dev/null; then
    THREADS=$(nproc)
else
    THREADS=4
fi

# ===== Temporary directory =====
TMP_DIR="./tmp_mmseqs_$$"
mkdir -p "$TMP_DIR"

echo "Running MMseqs2 locally..."
echo "Input: $INPUT_FASTA"
echo "Threads: $THREADS"
echo "TMP: $TMP_DIR"

# ===== Step 1: Create database =====
mmseqs createdb "$INPUT_FASTA" "$DB_NAME"

# ===== Step 2: Cluster =====
mmseqs cluster "$DB_NAME" "$CLUSTER_DB" "$TMP_DIR" \
    --min-seq-id 0.95 -s 1\
    -c 0.9 \
    --cov-mode 1 \
    --threads "$THREADS"
    --split-memory-limit 4G

# ===== Step 3: Export cluster assignments =====
mmseqs createtsv "$DB_NAME" "$DB_NAME" "$CLUSTER_DB" "$OUTPUT_TSV"

echo "Clustering completed: $OUTPUT_TSV"

# ===== Cleanup (optional) =====
rm -rf "$TMP_DIR"


