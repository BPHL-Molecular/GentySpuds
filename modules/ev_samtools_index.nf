#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process samtools_index{
    publishDir "${params.output}/samtools_indexedbam", mode: 'copy'   
    input:
    tuple val(samp), path(aln) 
    
    output:
    tuple val(samp), path( "*" )       

    script:
    """
    samtools index ${aln}
   
    """
    }