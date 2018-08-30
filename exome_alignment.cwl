#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "exome alignment with qc"
requirements:
    - class: SubworkflowFeatureRequirement
inputs:
    reference:
        type: File
        secondaryFiles: [.fai, .bwt, .sa, .ann, .amb, .pac, ^.dict]
    bams:
        type: File[]
    readgroups:
        type: string[]
    mills:
        type: File
        secondaryFiles: [.tbi]
    known_indels:
        type: File
        secondaryFiles: [.tbi]
    dbsnp:
        type: File
        secondaryFiles: [.tbi]
    bqsr_intervals:
        type: string[]?
    bait_intervals:
        type: File
    target_intervals:
        type: File
    per_target_intervals:
        type: File
    per_target_bait_intervals:
        type: File
    per_base_intervals:
        type: File
    per_base_bait_intervals:
        type: File
    omni_vcf:
        type: File
        secondaryFiles: [.tbi]
    picard_metric_accumulation_level:
        type: string
    minimum_mapping_quality:
        type: int?
    minimum_base_quality:
        type: int?
outputs:
    cram:
        type: File
        outputSource: alignment/final_cram
    mark_duplicates_metrics:
        type: File
        outputSource: alignment/mark_duplicates_metrics_file
    insert_size_metrics:
        type: File
        outputSource: qc/insert_size_metrics
    insert_size_histogram:
        type: File
        outputSource: qc/insert_size_histogram
    alignment_summary_metrics:
        type: File
        outputSource: qc/alignment_summary_metrics
    hs_metrics:
        type: File
        outputSource: qc/hs_metrics
    per_target_coverage_metrics:
        type: File?
        outputSource: qc/per_target_coverage_metrics
    per_target_hs_metrics:
        type: File?
        outputSource: qc/per_target_hs_metrics
    per_base_coverage_metrics:
        type: File?
        outputSource: qc/per_base_coverage_metrics
    per_base_hs_metrics:
        type: File?
        outputSource: qc/per_base_hs_metrics
    flagstats:
        type: File
        outputSource: qc/flagstats
    verify_bam_id_metrics:
        type: File
        outputSource: qc/verify_bam_id_metrics
    verify_bam_id_depth:
        type: File
        outputSource: qc/verify_bam_id_depth
steps:
    alignment:
        run: unaligned_bam_to_bqsr/workflow.cwl
        in:
            reference: reference
            bams: bams
            readgroups: readgroups
            mills: mills
            known_indels: known_indels
            dbsnp: dbsnp
            bqsr_intervals: bqsr_intervals
        out: [final_cram,mark_duplicates_metrics_file]
    qc:
        run: qc/workflow_exome.cwl
        in:
            cram: alignment/final_cram
            reference: reference
            bait_intervals: bait_intervals
            target_intervals: target_intervals
            per_target_intervals: per_target_intervals
            per_target_bait_intervals: per_target_bait_intervals
            per_base_intervals: per_base_intervals
            per_base_bait_intervals: per_base_bait_intervals
            omni_vcf: omni_vcf
            picard_metric_accumulation_level: picard_metric_accumulation_level
            minimum_mapping_quality: minimum_mapping_quality
            minimum_base_quality: minimum_base_quality
        out: [insert_size_metrics, insert_size_histogram, alignment_summary_metrics, hs_metrics, per_target_coverage_metrics, per_target_hs_metrics, per_base_coverage_metrics, per_base_hs_metrics, flagstats, verify_bam_id_metrics, verify_bam_id_depth]

