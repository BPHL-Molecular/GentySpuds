#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
==================================================================================
ev_gen
A Workflow to identify genotypes of Enteroviruses
==================================================================================
https://github.com/
#### Author
Tassy J. Bazile <tassy.bazile@flhealth.gov> - https://github.com/

--------------------------------------------------------------------------------
*/

/*
==================================================================================
Help Message
==================================================================================
*/

def helpMessage() {
    log.info"""
    >>
Usage:

The typical command for running the pipeline is as follows:
nextflow run ev_gen.nf --input_reads '*_{1,2}.fastq.gz' --outdir 'output path'

--input_reads   Path to short-read fastq files
--outdir        Chosen name of the output directory
<<
""".stripIndent()
}

//Show help message

if (params.help){
    helpMessage()
        exit 0
	}
/*
==================================================================================
Parameters
==================================================================================
*/

//params.input_reads = "" // format to provide paired-end reads  *_{1,2}.fastq') //params.genome = ""
//params.outdir = "$baseDir/fastqc_results"

//Step1:input data files

def L001R1Lst = []
def sampleNames = []
myDir = file("$params.input")

myDir.eachFileMatch ~/.*_1.fastq.gz/, {L001R1Lst << it.name}
L001R1Lst.sort()
L001R1Lst.each{
    def samp = it.minus("_1.fastq.gz")
        //println samp
   sampleNames.add(samp)
}
//println L001R1Lst
//println sampleNames


//Step2: process the inputed data
A = Channel.fromList(sampleNames)
//A.view()
B = Channel.fromPath(params.genome)


/*
==================================================================================
Channels
==================================================================================
*/

//reads_ch = Channel.fromFilePairs(params.input_reads, checkIfExists: true )


/*
==================================================================================
Module Importation
==================================================================================
*/

include { FASTQC as FASTQC_ev } from './modules/ev_gen_fastqc.nf'
include { trimmomatic as trimmomatic_ev } from './modules/ev_trim.nf'
include { bbtools as bbtools_ev } from './modules/ev_bbtools.nf' 
include { bwa_INDEX as index_ev } from './modules/ev_bwa_index.nf' 
include {bwa_aln as bwa_aln_ev } from './modules/ev_bwa_aln.nf'
//include {samtools_conv as samtools_conv_ev } from './ev_samtools_conv.nf'
include {samtools_sort as samtools_sort_ev } from './modules/ev_samtools_sort.nf'
include {samtools_index as samtools_index_ev } from './modules/ev_samtools_index.nf'
include {samtools_mpileup as samtools_mpileup_ev } from './modules/ev_samtools_mpileup.nf'
include {bcftools_mpileup as bcftools_mpileup_ev } from './modules/ev_bcftools_mpileup.nf'
include {scrub as scrub_ev } from './modules/ev_scrub.nf'
include {FASTQC2 as FASTQC2_clean } from './modules/ev_gen_fastqc2.nf'
include {scrub2} from './modules/ev_scrub2.nf'
include {kraken as kraken_ev} from './modules/ev_kraken.nf'
//include {bracken as bracken_ev} from './ev_bracken.nf'
include {skesa_asbl as skesa_asbl_ev} from './modules/ev_skesa_dnovo.nf'
include {bwa_INDEX_each} from './modules/ev_bwaIndexEach.nf'
include {bwa_aln_proc} from './modules/ev_aln_proc.nf'
include {samtools} from './modules/ev_sam_bam_sort.nf'
include {pilon} from './modules/ev_pilon_cons.nf'
include {quast} from './modules/ev_quast.nf' // added on 04/23
include {pyAsbProc} from './modules/ev_py1AssProc.nf' // added on 04/23
include {readsproc} from './modules/ev_readsproc.nf' // added on 04/23
include {blast_search} from './modules/ev_blast_search.nf'
include {multiqc} from './modules/ev_multqc.nf' //added on 04/23
include {readstat} from './modules/ev_py2readStat.nf'
include {krakenproc} from './modules/ev_py3Krakenproc.nf'
include {reportproc} from './modules/ev_py4ReportProc.nf'
include {unmapped_proc} from './modules/ev_unmapped.nf'
//include {ivar_cons as ivar_cons_ev } from './modules/ev_ivar_csensus.nf'

/*
==================================================================================

Workflow
==================================================================================


workflow readqc {

    FASTQC_ev(A) | trimmomatic_ev | bbtools_ev
}

workflow idx_genome {
    index_ev(B)  
}

workflow {

    readqc()
    idx_genome()
           
}

*/


//FASTQC_ev(A) | scrub_ev | trimmomatic_ev | bbtools_ev | FASTQC2_clean | multiqc | skesa_asbl_ev | kraken_ev | bwa_INDEX_each | bwa_aln_proc | samtools | pilon | blast_search | quast | pyAsbProc | readsproc | view
//blast_search(pilon)


workflow {
ch_fastqc=FASTQC_ev(A)
ch_scrub = scrub_ev(ch_fastqc)
ch_scrub.view()
ch_trim = trimmomatic_ev(ch_scrub)
ch_bbt = bbtools_ev(ch_trim)
ch_scrub2 = scrub2(ch_bbt)//added on 24/04/25
ch_fast_clean = FASTQC2_clean(ch_scrub2)
ch_multqc = multiqc(ch_fast_clean) // all qc
ch_kraken =  kraken_ev(ch_fast_clean)
//ch_brcken  = bracken_ev(ch_kraken)
ch_skesa = skesa_asbl_ev(ch_fast_clean)
ch_bwaidx_each = bwa_INDEX_each(ch_skesa)
ch_join = ch_fast_clean.join(ch_bwaidx_each) // sequences  and  genome index
//ch_join.view()
ch_aln = bwa_aln_proc(ch_join) // bwa alignment
ch_sam_bam = samtools(ch_aln) // sam to  bam and index
ch_join_cons = ch_sam_bam.join(ch_skesa)

ch_pilon = pilon(ch_join_cons)
ch_quast = quast(ch_pilon) // assembly metrics
ch_ablproc = pyAsbProc(ch_quast)// parsing asb metrics in a table file
ch_readproc = readsproc(ch_ablproc[0],ch_ablproc[1]) //path and table file
ch_readst =  readstat(ch_readproc[0], ch_readproc[1])// parsing (appending)reads metrics to table file ([0]path, [1] table file) 
ch_blast = blast_search(ch_pilon) // blast for assemblies
ch_kreport = krakenproc(ch_readst[0], ch_readst[1])// parsing(appending) Kraken report in table file
ch_report = reportproc(ch_kreport[0], ch_kreport[1]) // parsing final report from from table file to a new table
ch_unmap = unmapped_proc(ch_aln) //new
//krakenRep_list = ch_kraken.map{it -> it[1]}.collect()
//krakenRep_list.view()
//kraken_grouped_ch = grouping_intodir_kraken(krakenRep_list)
//kraken_summary_ch = kraken_summary(kraken_grouped_ch)
}


/*
workflow {
    //FASTQC_ev(A) | trimmomatic_ev | bbtools_ev
    //FASTQC_ev(A)
    
    ch_trim = trimmomatic_ev(FASTQC_ev(A))
    ch_bbt = bbtools_ev(ch_trim)
    ch_scrub = scrub_ev(ch_bbt)// scrub process  
    ch_idx = index_ev(B)
    //ch_bbt.view()// inactive
    //ch_idx.view()// inactive
    ch_idx.combine(ch_bbt).view()
    ch_aln = bwa_aln_ev(ch_idx.combine(ch_bbt))
    //ch_sam_conv = samtools_conv_ev(ch_aln)// inactive
    //ch_sam_sort = samtools_sort_ev(ch_sam_conv)// inactive
    ch_sam_sort = samtools_sort_ev(ch_aln)
    ch_sam_index = samtools_index_ev(ch_sam_sort)// For visualization purpose
    ch_sam_mpil = samtools_mpileup_ev(ch_sam_sort)// consensus assembly
    //ch_ivar_cons = ivar_cons_ev(ch_sam_mpil) // inactive
    ch_ref_bam = ch_idx.combine(ch_sam_sort)
    ch_ref_bam.view()
    bcftools_mpileup_ev(ch_ref_bam)
}
*/