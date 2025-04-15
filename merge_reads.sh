#!/bin/bash

# merge_reads.sh
# Merges paired-end FASTQ files using PEAR

# Input and output directories
path="/Users/leandrojorqueravalero/Desktop/PhD/Miseq/RT_test-v2/feb-OOF"
outdir="$path/merged"
mkdir -p "$outdir"

# Loop through R1 files
for r1 in "$path"/*_R1_001.fastq.gz
do
  base=$(basename "$r1" _R1_001.fastq.gz)
  r2="$path/${base}_R2_001.fastq.gz"

  echo "Merging $base with PEAR..."

  pear -f "$r1" -r "$r2" -o "$outdir/$base" > /dev/null

  if [ -f "$outdir/${base}.assembled.fastq" ]; then
    echo "✔️ Merged: ${base}.assembled.fastq"
  else
    echo "❌ Merging failed for $base"
  fi

  echo ""
done

