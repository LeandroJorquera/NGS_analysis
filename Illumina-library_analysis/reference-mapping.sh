#!/bin/bash
#SBATCH --job-name=InsertSeq_Map
#SBATCH --output=./InsertSeqLogs/Map_%j.out
#SBATCH --error=./InsertSeqLogs/Map_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH --partition=haswell
set -euo pipefail

# =========================
# CONFIGURACION
# =========================

# Source data
TRIM_DIR="/homes/users/ljorquera/scratch/data/illumina-library/raw/filtered"

REF_DIR="/homes/users/ljorquera/scratch/data/illumina-library/genomes"

OUT_DIR="/homes/users/ljorquera/scratch/data/illumina-library/bam"

mkdir -p "${OUT_DIR}"

REF="${REF_DIR}/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

# =========================
# MODULOS
# =========================

module purge
module load modulepath/haswell
module load BWA/0.7.19-GCCcore-14.2.0
module load SAMtools/1.22.1-GCC-14.2.0

echo "Inicio: $(date)"
echo "FASTQ dir: ${TRIM_DIR}"
echo "Referencia: ${REF}"
echo "Output dir: ${OUT_DIR}"

# =========================
# COMPROBAR REFERENCIA
# =========================

if [[ ! -f "${REF}" ]]; then
    echo "ERROR: No se encuentra la referencia ${REF}"
    exit 1
fi

# =========================
# INDEXAR REFERENCIA SI HACE FALTA
# =========================

if [[ ! -f "${REF}.bwt" || ! -f "${REF}.sa" || ! -f "${REF}.ann" || ! -f "${REF}.amb" || ! -f "${REF}.pac" ]]; then
    echo "Indexando referencia con bwa index..."
    bwa index "${REF}"
else
    echo "Índices de BWA ya presentes. Se reutilizan."
fi

if [[ ! -f "${REF}.fai" ]]; then
    echo "Indexando referencia con samtools faidx..."
    samtools faidx "${REF}"
else
    echo "Índice FASTA (.fai) ya presente. Se reutiliza."
fi

# =========================
# MAPPING
# =========================

for SAMPLE in E3 Hs Rr
do
    echo "Procesando ${SAMPLE}..."

    FASTQ="${TRIM_DIR}/matched_reads_${SAMPLE}.fastq"

    if [[ ! -f "${FASTQ}" ]]; then
        echo "ERROR: No se encuentra ${FASTQ}"
        exit 1
    fi

    bwa mem -t "${SLURM_CPUS_PER_TASK}" "${REF}" "${FASTQ}" \
        | samtools view -bS - \
        | samtools sort -o "${OUT_DIR}/${SAMPLE}.bam"

    samtools index "${OUT_DIR}/${SAMPLE}.bam"
done
        

echo "Fin: $(date)"
