#!/bin/bash

# merge_reads_bbmerge.sh
# Merges paired-end FASTQ files using BBMerge (from BBTools)

# Input and output directories -- HAVE FILES IN LOCAL, NOT CLOUD
path='/Users/leandro/Desktop/github/NGS-data/SeV-ORF1_251003/raw'
outdir="$path/merged"
mkdir -p "$outdir"

# Loop through R1 files
for r1 in "$path"/*_R1_001.fastq.gz
do
  base=$(basename "$r1" _R1_001.fastq.gz)
  r2="$path/${base}_R2_001.fastq.gz"

  echo "Merging $base with BBMerge..."

  bbmerge.sh in1="$r1" in2="$r2" out="$outdir/${base}.merged.fastq.gz" 2>/dev/null

  if [ -f "$outdir/${base}.merged.fastq.gz" ]; then
    echo "✔️ Merged: ${base}.merged.fastq.gz"
  else
    echo "❌ Merging failed for $base"
  fi

  echo ""
done


