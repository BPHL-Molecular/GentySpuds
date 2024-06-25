#!/usr/bin/env nextflow

// Indexing genome files for alignment purpose 
nextflow.enable.dsl = 2

process bwa_INDEX {
    publishDir "${params.output}/bwa_index", mode: 'copy' // new changes   
    input:
    path gen
    
    output:
    //path "*"
    path ("*")
    //tuple path( gen ), path( "*" ), emit: bwa_index       
    script:
    """
    mkdir -p ref_genome
    cp ${gen} ref_genome/     
    bwa index -a is ref_genome/${gen}
    #bwa index -a is $gen
   
    """
    }