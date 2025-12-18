#!/bin/bash

input_dir=$1
email=$2
meta_suffix="${3:-}"

for dir in "${input_dir}"/*
do
    sampleid=$(basename "$dir")
    new_sampleid=${sampleid/_/-}
    run=$(basename "$input_dir" | tr '_' '-')

    combined_runs=""
    combined_fcid=""

    for flowcellrun in "${dir}"/*
    do
        flowcellrunid=$(basename "$flowcellrun")
        fcid=$(echo "$flowcellrunid" | cut -d'_' -f4)
        combined_fcid+="${fcid}-"
    done

    suffix=${combined_fcid%-}
    if [[ -n "$meta_suffix" ]]; then
         suffix="${suffix}_${meta_suffix}"
    fi

    sh /hpc/diaggen/software/development/Epi2Me_wf-human-variation_feature_umcu_v272suffix/run.sh \
        $input_dir \
        "/hpc/diaggen/projects/ONT_wf-human-variation/"$run"_"${new_sampleid}"_"${suffix} \
        /hpc/diaggen/data/databases/ref_genomes/Homo_sapiens.GRCh38.GCA_000001405.15/no_alt_plus_hs38d1_analysis_set/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna \
        $new_sampleid \
        $email \
        --suffix $suffix
done
