#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process bwa_aln {
    publishDir "${params.output}/bwa_align", mode: 'copy'
    input:
    //tuple path(gen), path( "*" ), val(seq)
    tuple path(gen), val(seq)    
    //path(gen_idx)
    //tuple  val(seq), path(R1), path(R1)
    //tuple path( genome ), path( "*" ), val( sample_id ), path( reads )

    output:
    tuple val(seq), path("${seq}.mapped.sam")
    //path ("*")

    //gen_idx = `find -L ./ -name "*.amb" | sed 's/.amb//'`
    //#bwa aln ${gen_idx} -t $task.cpus ${seq}_1.fq.gz > ${seq}_1.sai
    //#bwa aln ${gen_idx} -t $task.cpus ${seq}_2.fq.gz > ${seq}_2.sai
    script:
    """     
    # Aligning pe reads
    bwa mem -t $task.cpus ${gen}/*.fasta ${params.output}/${seq}/${seq}_1_clean.fq.gz ${params.output}/${seq}/${seq}_2_clean.fq.gz > ${seq}.mapped.sam
    #bwa mem -t $task.cpus ${gen}/*.fasta ${params.output}/${seq}/${seq}_1.fq.gz ${params.output}/${seq}/${seq}_2.fq.gz > ${seq}.mapped.sam  
    # combining info from two files
    #bwa sampe ref ${seq}_1.sai {${seq}_2.sai ${seq}_1.fq.gz ${seq}_2.fq.gz > ${seq}_12_pe.sam 
    
    """
    }