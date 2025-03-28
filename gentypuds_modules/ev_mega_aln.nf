#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process mega_aln{
    //publishDir "${params.output}/", mode: 'copy'
    input:
    val xp //samp    
    
    //tuple  val(seq), path(R1), path(R1)
    //tuple path( genome ), path( "*" ), val( sample_id ), path( reads )

    output:
    val xp //samp
    
    //path("${seq}.skesa.fa")
    //path ("*")
    //E180-R2_S22/pilon_cons/E180-R2_S22_pilon.fasta   

    script:
    """     
    # Multiple alignment btw sample-assemblies and ref genomes
    mkdir -p ${params.output}/${xp}/mega_out/mega_aln #
    megacc -a ${params.mao} -d ${params.output}/${xp}/ev_vp1/${xp}_vp1_corr.fasta -o ${params.output}/${xp}/mega_out/mega_aln/${xp}_aln.meg
    # May delete vp1 fasta sequences
    # rm ${params.output}/${xp}/ev_vp1/*.fasta 
       
    """
}

// Size per contig (moodule loadseqkit)
// seqkit fx2tab --length --name --header-line file.fasta
