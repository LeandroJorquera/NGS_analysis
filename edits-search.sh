#!/bin/bash

# Path to merged FASTQ files
path="/Users/leandro/Desktop/github/NGS-data/dec-OOF/round2/merged"

# Create associative array to store results per sample
declare -A output

# Pattern for spontaneous background signal (from control sample only)
control_sample="$path/dec-OOF-1_S1_L001.merged.fastq.gz"
spont=0
if [[ -f "$control_sample" ]]; then
  spont=$(zgrep -io "gagcACGcttgTGATGGCAGA" "$control_sample" | wc -w)
else
  echo "Control sample not found at: $control_sample"
  exit 1
fi

echo "Background spontaneous signal (control): $spont"

# Loop through all merged FASTQ files
for fastq in "$path"/*.merged.fastq.gz
do
  filename=$(basename "$fastq")

  # Total number of reads
  total=$(zgrep -c "^@" "$fastq")

  # Edited reads with intended mutation
  edited=$(zgrep -io "gagcACGcttgTGATGGCAGA" "$fastq" | wc -w)

  # Calculate editing efficiency
  if [ "$total" -gt 0 ]; then
    efficiency=$(echo "scale=3 ; (($edited - $spont) / $total) * 100" | bc)
  else
    efficiency="NA"
  fi

  # Save data into output array
  output["$filename"]="$total\t$edited\t$efficiency"
done

# Output results to a file
output_file="editing_output.txt"
{
  echo -e "Sample\tTotal_Reads\tEdited_Reads\tEfficiency(%)"
  for key in "${!output[@]}"; do
    echo -e "$key\t${output[$key]}"
  done
} | sort -k4 -nr > "$output_file"

# Open result file
open "$output_file"

