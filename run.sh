#!/bin/bash
set -euo pipefail

workflow_path='/hpc/diaggen/software/production/Epi2Me_wf-human-variation'

# Set input and output dirs
input=`realpath -e $1`
output=`realpath $2`
reference_path=$3
sampleid=$4
email=$5
optional_params=( "${@:6}" )

mkdir -p $output && cd $output
mkdir -p log

if ! { [ -f 'workflow.running' ] || [ -f 'workflow.done' ] || [ -f 'workflow.failed' ]; }; then
touch workflow.running

sbatch <<EOT
#!/bin/bash
#SBATCH -c 2
#SBATCH -t 48:00:00
#SBATCH --mem=20G
#SBATCH --gres=tmpspace:20G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=$email
#SBATCH --error=slurm-%j.err
#SBATCH --output=slurm-%j.out

export NXF_JAVA_HOME='$workflow_path/tools/java/jdk'

$workflow_path/tools/nextflow/nextflow run $workflow_path \
    -c $workflow_path/umcu_hpc.config \
    --bam $input \
    --ref $reference_path \
    --sample_name $sampleid \
    --out_dir $output \
    --snp \
    --cnv \
    --sv \
    --str \
    --mod \
    --phased \
    --bam_min_coverage 1 \
    --annotation false \
    -profile slurm \
    -resume -ansi-log false \
    ${optional_params[@]:-""}

if [ \$? -eq 0 ]; then
    echo "Nextflow done."

    #echo "Zip work directory"
    #find work -type f | egrep "\.(command|exitcode)" | zip -@ -q work.zip

    #echo "Remove work directory"
    #rm -r work

    #echo "Creating md5sum"
    #find -type f -not -iname 'md5sum.txt' -exec md5sum {} \; > md5sum.txt

    echo "Epi2Me_wf-human-variation workflow completed successfully."
    rm workflow.running
    touch workflow.done

    echo "Change permissions"
    chmod 775 -R $output

    exit 0
else
    echo "Nextflow failed"
    rm workflow.running
    touch workflow.failed

    echo "Change permissions"
    chmod 775 -R $output

    exit 1
fi
EOT
else
echo "Workflow job not submitted, please check $output for 'workflow.status' files."
fi

