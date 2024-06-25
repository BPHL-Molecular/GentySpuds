#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process bcftools_mpileup {
    publishDir "${params.output}/bcftools_mpileup", mode: 'copy' // new changes   
    input:
    tuple path(gen), val(samp), path(alnbam)
    
    output:
    // path "*"
    // path ("*")
    tuple val(samp), path( "*" )
    //tuple path( gen ), path( "*" ), emit: bwa_index       
    script:
    """
    # O output type v uncompressed vcf
    bcftools mpileup -Ov -f ${gen}/*.fasta ${alnbam} -o ${samp}
   
    """
    }