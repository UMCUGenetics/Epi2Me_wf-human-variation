#!/bin/bash
#SBATCH -c 2
#SBATCH -t 4:00:00
#SBATCH --mem=100G
#SBATCH --gres=tmpspace:100G

# Tags from nextflow.config
e2l_base_tag="sha8ecee6d351b0c2609b452f3a368c390587f6662d"
e2l_snp_tag="sha8cc7e88ff71bf593d7852309a31d3adb29a7caeb"
e2l_sv_tag="sha8134f9fef5e19605c7fb4c1348961d6771f1af79"
e2l_mod_tag="shaa7bf2b62946eeb7646b9b9d60b892edfc3b3a52c" 
cnv_tag="sha428cb19e51370020ccf29ec2af4eead44c6a17c2"
str_tag="shadd2f2963fe39351d4e0d6fa3ca54e1064c6ec057"
spectre_tag="sha42472d37a5a992c3ee27894a23dce5e2fff66d27"
snpeff_tag="shaff5aecfe85e945f49215fa3d43b9ed4ae352bd5c"
#longphase_tag="sha4ff1cd9a6eee338a414082cb24f943bcc4ce8e7c"
common_sha="shaabceef445fb63214073cbf5836fdd33c04be4ac7"

# Nextflow singularity cache directory
cd /hpc/diaggen/software/singularity_cache

# Pulling the containers
echo "# Pulling ontresearch-wf-human-variation-${e2l_base_tag}.img"
singularity pull --disable-cache --name ontresearch-wf-human-variation-${e2l_base_tag}.img docker://ontresearch/wf-human-variation:${e2l_base_tag}
echo "# Pulling ontresearch-wf-human-variation-snp-${e2l_snp_tag}.img"
singularity pull --disable-cache --name ontresearch-wf-human-variation-snp-${e2l_snp_tag}.img docker://ontresearch/wf-human-variation-snp:${e2l_snp_tag}
echo "# Pulling ontresearch-wf-human-variation-sv-${e2l_sv_tag}.img"
singularity pull --disable-cache --name ontresearch-wf-human-variation-sv-${e2l_sv_tag}.img docker://ontresearch/wf-human-variation-sv:${e2l_sv_tag}
echo "# Pulling ontresearch-modkit-${e2l_mod_tag}.img"
singularity pull --disable-cache --name ontresearch-modkit-${e2l_mod_tag}.img docker://ontresearch/modkit:${e2l_mod_tag}
echo "# Pulling ontresearch-wf-cnv-${cnv_tag}.img"
singularity pull --disable-cache --name ontresearch-wf-cnv-${cnv_tag}.img docker://ontresearch/wf-cnv:${cnv_tag}
echo "# Pulling ontresearch-wf-human-variation-str-${str_tag}.img"
singularity pull --disable-cache --name ontresearch-wf-human-variation-str-${str_tag}.img docker://ontresearch/wf-human-variation-str:${str_tag}
echo "# Pulling ontresearch-snpeff-${snpeff_tag}.img"
singularity pull --disable-cache --name ontresearch-snpeff-${snpeff_tag}.img docker://ontresearch/snpeff:${snpeff_tag}
echo "# Pulling ontresearch-wf-common-${common_sha}.img"
singularity pull --disable-cache --name ontresearch-wf-common-${common_sha}.img docker://ontresearch/wf-common:${common_sha}
echo "# Pulling ontresearch-spectre-${spectre_tag}.img"
singularity pull --disable-cache --name ontresearch-spectre-${spectre_tag}.img docker://ontresearch/spectre:${spectre_tag}
