#!/usr/bin/env bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=YOUREMAILADDRESS
#SBATCH --job-name=gentyspuds
#SBATCH --mail-type=NONE
#SBATCH --cpus-per-task=24
#SBATCH --mem=200gb
#SBATCH --time=10:00:00
#SBATCH --output=gentyspuds.log
#SBATCH --error=gentyspuds_%j.err

module purge

module load nextflow apptainer

export APPTAINER_CACHEDIR="/COLOR/PATH/YOURUSERNAME/"nextflow_temp/ # Rename parts between quotes and remove the quotes / for storage of nexflow temporary directory

export NXF_APPTAINER_CACHEDIR="/COLOR/PATH/YOURUSERNAME/"nextflow_temp/


###############################################################################

nextflow run gentyspuds_wf.nf -params-file params.yaml -resume 
###############################################################################

# Concatenating all the indivual(per sampleID) tables into one combined table
sort ./output/*/report.txt | uniq > ./output/sum_report.txt
sed -i '/SampleID\tSpeciesID/d' ./output/sum_report.txt

sed -i "1i SampleID\tSpeciesID_kraken\tKraken_percent\tNum_clean_reads\tAvg_readlength\tAvg_read_qual\tEst_coverage\tNum_contigs\tLongest_contig\tN50\tL50\tTotal_length\tGC_content\tKrEV_Type\tKr_%fragNtaxon" ./output/sum_report.txt

# Adding date to output dir, remove work and cache to clear space.
dt=$(date "+%Y%m%d%H%M%S")
mv ./output ./output-$dt
rm -r ./work

