#!/bin/bash

# analyze_reads.sh
# Greps specific sequences from merged FASTQ files and reports counts

# Set merged reads directory
merged_dir="/Users/leandrojorqueravalero/Desktop/PhD/Miseq/RT_test-v2/feb-OOF/merged"

# Loop through merged FASTQ files
for merged in "$merged_dir"/*.assembled.fastq
do
  base=$(basename "$merged" .assembled.fastq)
  echo "Analyzing $base..."

  # Count total reads (1 per 4-line block, line starting with @)
  total=$(grep -c "^@" "$merged")
  echo "Total merged reads: $total"

  # Count WT reads
  WT=$(grep -io "gagcACGTGATGGCAGAg" "$merged" | wc -w)
  echo "Number of WT reads: $WT"

  percent=$(echo "scale=3 ; ($WT / $total) * 100" | bc)
  echo "Percentage of WT reads: $percent"

done

