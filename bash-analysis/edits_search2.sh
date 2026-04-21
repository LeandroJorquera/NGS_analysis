#!/bin/bash

# Path to merged FASTQ files
path="/Users/leandro/Desktop/github/NGS-data/RTtest6-sorted/merged"

# Pattern for spontaneous background signal (from control sample only)
control_sample="$path/dec-OOF-1_S1_L001.merged.fastq.gz"
spont=0
if [[ -f "$control_sample" ]]; then
  spont=$(zgrep -io "gagcACGcttgTGATGGCAGA" "$control_sample" | wc -w)
else
  echo "Control sample not found at: $control_sample"
  exit 
fi

echo "Background spontaneous signal (control): $spont"

# Create an output file for the results
output_file="editing_output.txt"
echo -e "Sample\tTotal_Reads\tEdited_Reads\tEfficiency(%)" > "$output_file"

# Loop through all merged FASTQ files
for fastq in "$path"/*.merged.fastq.gz
do
  filename=$(basename "$fastq")

  # Total number of reads (each read starts with "@", every 4 lines)
  total=$(zgrep -c "^@" "$fastq")

  # Edited reads with intended mutation
  edited=$(zgrep -io "gagcACGcttgTGATGGCAGA" "$fastq" | wc -w)

  # Calculate editing efficiency
  if [ "$total" -gt 0 ]; then
    efficiency=$(echo "scale=3 ; (($edited - $spont) / $total) * 100" | bc)
  else
    efficiency="NA"
  fi

  # Append the data to the output file
  echo -e "$filename\t$total\t$edited\t$efficiency" >> "$output_file"
done

# Output results
echo "Results written to $output_file"

# Open the result file (optional, for macOS)
open "$output_file"
