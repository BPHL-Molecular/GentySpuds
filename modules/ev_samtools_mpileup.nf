#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process samtools_mpileup {
    publishDir "${params.output}/samtools_mpileup", mode: 'copy' // new changes   
    input:
    tuple val(samp), path(aln_sorted)
    
    output:
    //tuple val(samp), path( "*.mpileup*" )
    tuple val(samp), path("${samp}.*")       
    script:
    """
    # -aa every position, - A orphan reads, -d depth -Q minimum base quality
    # samtools mpileup -aa -A -d 1000000 -Q 20 ${aln_sorted} -o ${samp}.mpileup
    samtools mpileup -aa -A -d 1000 -Q 0 ${aln_sorted} | ivar consensus -t 0 -q 20 -p ${samp}
    """
    }