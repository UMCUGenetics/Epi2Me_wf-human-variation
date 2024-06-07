#!/bin/bash
#SBATCH -c 2
#SBATCH -t 4:00:00
#SBATCH --mem=100G
#SBATCH --gres=tmpspace:100G

name="wf-human-variation"

# Tags from nextflow.config
e2l_base_tag="sha2b856c1f358ddf1576217a336bc0e9864b6dc0ed"
e2l_snp_tag="sha17e686336bf6305f9c90b36bc52ff9dd1fa73ee9"
e2l_sv_tag="shac591518dd32ecc3936666c95ff08f6d7474e9728"
e2l_mod_tag="sha0253e9e9ba92aacc852ba376edefe8ff0932f71a"
cnv_tag="sha428cb19e51370020ccf29ec2af4eead44c6a17c2"
str_tag="shaa2f49ce57886426516eadd4048b6fdf9c22c7437"
spectre_tag="sha5a2890023dc7a7899f47585103b4f5762fb9d1b3"
snpeff_tag="sha313729d816872d70b410752001a0e2654eb88807"
common_sha="sha338caea0a2532dc0ea8f46638ccc322bb8f9af48"

# Nextflow singularity cache directory
cd /hpc/diaggen/software/singularity_cache

# Pulling the containers
echo "# Pulling ontresearch-${name}-${e2l_base_tag}.img"
singularity pull --disable-cache --name ontresearch-${name}-${e2l_base_tag}.img docker://ontresearch/${name}:${e2l_base_tag}
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