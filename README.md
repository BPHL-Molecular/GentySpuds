# GentySpuds
A web-deployed pipeline to seek genotyping for Enterovirus.
#An enterovirus is a small and enveloped mRNA virus.
# Introduction
Genotyping is a way of putting a virus into categories based on similar genes.
Determining the genotype of viruses is important not only in epidemiology studies, but also for efficient vaccine development
and treatment       

# Workflow

# Software Tools implemented

# Installation

# Usage
GentySpuds takes as input raw sequencing reads in FASTQ format, and can process gzipped files directly.
nextflow run ev_gen_wf.nf -params-file params.yaml -resume
Make sure your all your fastq files are stored in one directory.