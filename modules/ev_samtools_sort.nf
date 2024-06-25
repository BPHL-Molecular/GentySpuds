#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process samtools_sort{
    publishDir "${params.output}/samtools_sortedbam", mode: 'copy'   
    input:
    tuple val(samp), path(aln) 
    
    output:
    tuple val(samp), path( "*.sorted.bam" )       

    script:
    """
    samtools sort -o ${samp}.sorted.bam ${aln}
   
    """
    }