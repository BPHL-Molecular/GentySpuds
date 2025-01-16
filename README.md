# GentySpuds
A web-deployed pipeline to seek genotyping for Enterovirus.
## An enterovirus is a small and enveloped mRNA virus that can cause infections in people of all ages.

# Introduction
Genotyping is a way of putting a virus into categories based on similar genes.
Determining the genotype of viruses is important not only in epidemiology studies, but also for efficient vaccine development
and treatment       

# Workflow

# Software Tools implemented
FASTQC, trimmomatic, bbtools, sra_human_scrubber, multiqc, skesa, kraken, bwa, samtools, pilon, quast, Blast, clustalo, iqtree etc. 
# Installation
## Clone repository
## create your cada environment

# Usage
GentySpuds takes as input raw sequencing reads in FASTQ format, and can process gzipped files directly.
nextflow run ev_gen_wf.nf -params-file params.yaml -resume  
Make sure your all your fastq files are stored in one directory.

## Overview of the arguments
Nexflow is a worflow programming language that allows reproducibility, portability, scalability of large datassets analysis.

ev_gen_wf.nf is the main script workflow to run the pipeline.

params.yaml is a yml file that provides a convenient way to feed the worklow with the input data, espcially when there multiple parameters.