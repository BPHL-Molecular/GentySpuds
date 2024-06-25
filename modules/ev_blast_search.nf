#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process blast_search {
    //publishDir "${params.output}/skesa_dnovo", mode: 'copy'
    input:
    val samp    
    
    //tuple  val(seq), path(R1), path(R1)
    //tuple path( genome ), path( "*" ), val( sample_id ), path( reads )

    output:
    //path("${seq}.skesa.fa")
    //path ("*")
    val samp
    script:
    """     
    # Assembling reads
    mkdir -p ${params.output}/${samp}/blast_results
    blastn -db ${params.blastevdb}/${params.evdbname} -query ${params.output}/${samp}/pilon_cons/${samp}_pilon.fasta -out ${params.output}/${samp}/blast_results/${samp}_blast.tsv -outfmt "6 pident evalue" -max_target_seqs 5      
    """
}