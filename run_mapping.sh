#!/usr/bin/env bash
set -euo pipefail

# === Input files (edit these if needed) ===
WT_FA="/Users/leandro/Desktop/github/NGS-data/ONT/rhv2-wt-amplicon.fasta"
EDIT_FA="/Users/leandro/Desktop/github/NGS-data/ONT/jpcr-rhv2.fasta"
READS="/Users/leandro/Desktop/github/NGS-data/ONT/RHv2HDR_241125/HDR-only/7HRBQL_1_HDR.fastq"

# === Output prefixes ===
REF="alleles.fasta"
BAM_RAW="aln.raw.bam"
BAM_SORTED="aln.sorted.bam"
BAM_FILTERED="aln.filtered.bam"

echo "=== Step 1: Build combined reference ==="
cat "$WT_FA" "$EDIT_FA" > "$REF"
echo "Created $REF"

echo "=== Step 2: Map ONT reads with minimap2 ==="
minimap2 -ax map-ont "$REF" "$READS" \
    | samtools view -bS - > "$BAM_RAW"

echo "Sorting BAM..."
samtools sort -o "$BAM_SORTED" "$BAM_RAW"
samtools index "$BAM_SORTED"

echo "=== Step 3: Filter primary alignments & low MAPQ ==="
# Remove secondary (0x100), supplementary (0x800), QCfail (0x200), duplicates (0x400)
# 2308 = 0x904 (secondary + supplementary + QCfail + duplicate)
samtools view -F 2308 -q 20 -b "$BAM_SORTED" > "$BAM_FILTERED"
samtools index "$BAM_FILTERED"

echo "Done."
echo "Outputs:"
echo "  Combined reference:  $REF"
echo "  Raw BAM:             $BAM_RAW"
echo "  Sorted BAM:          $BAM_SORTED"
echo "  Filtered BAM:        $BAM_FILTERED (final)"

