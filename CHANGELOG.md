# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v2.2.3]
### Added
- Clair3 HAC and SUP V5.0.0 models
### Changed
- Update Spectre to v0.2.1, which generates a predicted karyotype that is included in the HTML report.
- Improved reliability of the haplocheck process.
### Fixed
- infer_sex causing SNP subworkflow to wait unnecessarily on completion of mosdepth
- Alignment QC report crashing due to missing unmapped histograms
- Unsupported dna_r10.4.1_e8.2_5khz_400bps_sup@v4.2.0 model
- Missing Clair3 mapping for v3.5.1 models
  - The missing model mapping is provided for completeness, users are strongly encouraged to re-basecall data on newer models to take advantage of significant improvements.

### Changed
- Workflow will exit early with an informative message and alignment report if there are no aligned reads in the BAM

## [v2.2.2]
### Changed
- Workflow emitting `OPTIONAL_FILE` in some cases.
- File format of alignment files created by the workflow can be explicitly controlled with `--output_xam_fmt [bam|cram]`.
  - The default is CRAM to match existing behaviour, for BAM use `--output_xam_fmt bam`.
- Enable RUST_BACKTRACE to automatically provide improved log messages for modkit issues.
### Removed
- JBrowse configuration as it is no longer supported.
- Unused `merge_threads` parameter.
### Fixed
- "No such file or directory" error for SV tandem repeat BED when user has assets in /data/

## [v2.2.1]
### Changed
- Reconciled workflow with wf-template v5.1.4
### Fixed
- `modkit sample-probs` failing with downsampling and re-alignments.
- Workflow waiting for `mosdepth` and `readStats` processes when `--bam_min_coverage 0`.

## [v2.2.0]
### Added
- Output `{{sample}}.stats.json` file describing some key metrics for the analysis.
- Summary of gene coverage if a 4-column BED is provided.
- Automated sex determination using relative coverage of chrX and chrY.
- Retry strategy added to `snp:aggregate_pileup_variants` to prevent out of memory error.

### Changed
- `--GVCF --phased` will produce a phased GVCF.
- Changed default phasing algorithm to `whatshap`, with the possibility to change the phasing to `longphase` with `--use_longphase true`.
    - The intermediate phasing is still performed using `longphase`.
- Setting `--snp --sv --phased` will emit individually phased SNPs and SVs.
- Phased bedMethyl files now follow the pattern `{{ alias }}.wf_mods.{{ haplotype }}.bedmethyl.gz`.
- `--sex` parameter uses `XX` and `XY` rather than "female" and "male".
- Update `modkit` to v0.2.6.
- Improved modkit runtime by increasing default threads and increasing the default interval size.
- Improved modkit runtime by increasing the default interval size and running modkit on individual contigs.
- `modkit` is now run only on chromosomes 1-22, X, Y and MT, unless `--include_all_ctgs` is provided.
- Increased minimum CPU requirement for the workflow to 16.
- Filtering of SVs using a BED file now includes sites only partially overlapping the specified regions.
- `basecaller_cfg` will be inferred from the `basecall_model` DS key of input read groups, if available
    - Providing `--basecaller_cfg` will not be required if `basecall_model` is present in the DS tag of the read groups of the input BAM
    - `--basecaller_cfg` will be ignored if a `basecall_model` is found in the input BAM
- Reconciled workflow with wf-template v5.1.2
- Update to Clair3 v1.0.8.
- Update to longphase v1.7.1.

### Fixed
- Update schema to allow selection of multiple BAM files per sample in EPI2ME.
- Spectre CNV report not handling cases when no CNVs detected.
- Lines denoting normal maximum and pathogenic minimum thresholds now correctly displayed on STR repeat content plots.
- Workflow will not emit `sample.cram` if `sample.haplotagged.cram` has been created by the workflow to save storage.
- Emitting nonsense `input.1` file

### Removed
- Single-step joint phasing of SV and SNP.
- `--output_separate_phased` as the workflow emits only individually phased VCFs.
- A copy of the reference and the generated reference cache is no longer output by the workflow.
    - The workflow encourages use of readily available standard reference sequences, so re-emitting the input reference as a workflow output is unnecessarily consuming disk space.

## [v2.1.0]
### Changed
- ClinVar version in SnpEff container updated to version 20240307.
- Convert to BAM only when `--cnv --use_qdnaseq` is selected.
- Update to Clair3 v1.0.6.
- Update Spectre to fix an error when parsing Clair3 VCFs with multiple AFs.
- Support for an input folder of multiple BAM files per sample with `--bam` (instead of only allowing a single BAM per sample).
- `refine_with_sv` to be run by chromosome in order to reduce memory footprint.

### Fixed
- Force minimap2 to clean up memory more aggressively. Empirically this reduces peak-memory use over the course of execution.
- Handling of input VCF files with `--vcf_fn`.
- `--phased --sv --snp` generates a truncated VCF file when `#` appears in the VCF `INFO` field
- Some reporting scripts using too much memory.

### Removed
- CRAM as supported input format.
- `old_ref` parameter as providing the reference of an existing CRAM is no longer needed.

## [v2.0.0]
### Changed
- CNV calling with `--cnv` is now performed using Spectre, which is optimised for long reads.
    - Legacy CNV calling using QDNAseq may still be carried out with `--cnv --use_qdnaseq`.
    - The bin size parameter has been renamed from `--bin_size` to `--qdnaseq_bin_size`.
- Skip CNV CRAM to BAM conversion if downsampling is required, to avoid creating an unnecessary intermediate file.
- The output of `--depth_intervals` now has `.bedgraph.gz` extension.
- SV workflow outputs SVs in the autosomes, sex chromosomes and MT; use `--include_all_ctgs` to output calls on all the sequences.

### Added
- Output definitions for coverage files.
- N50 and mean coverage added to alignment report.

### Fixed
- EPI2ME Desktop incorrectly allowed selection of directory for `tr_bed`.
- `failedQCReport` failing to generate a report.

## [v1.11.0]
### Changed
- Add an additional `whatshap haplotag` process after the final VCF phasing.
- Updates to the phasing subworkflow significantly impact the runtime and storage requirement for the workflow, as detailed [here](README.md#9-phasing-variants).
- Several performance improvements which should noticeably reduce the running time of the workflow
### Fixed
- Updated the version of Straglr, which addresses the following:
    - Repeats can now be called in *RFC1*
    - Start position of called STRs is 1-based rather than 0-based
    - VCF headers now match those in the `FORMAT` field
- Generate `allChromosomes.bed` using `samtools faidx` index instead of `pyfaidx`, to avoid a KeyError
- Inconsistent file ownership of bundled Clair3 model files which could lead to subuid errors in some environments

## [v1.10.1]
### Fixed
- Bug report form.

## [v1.10.0]
### Added
- Clair3 4.3.0 models.

### Changed
- `--phase_vcf`, `--joint_phasing` and `--phase_mod` are now deprecated for `--phased`; see the [README](README.md#9-phasing-variants) for more details.
- `--use_longphase_intermediate` is now deprecated, and `--use_longphase false` will use `whatshap` throughout consistently
- Running `--phase --snp --use_longphase false` will now phase indels too
- `--basecalling_cfg` currently provides the configuration to Clair3.
- The `clair3:` prefix to Clair3 specific models is no longer required.

### Fixed
- SNP workflow ignoring the mitochondrial genome.
- CNV report generation fails if there is no consensus on the copy number of a chromosome
    - `Undetermined` category has been added to the `Chromosome Copy Summary` to account for these cases
- `readStats` reports metrics on the downsampled BAM when `--downsample_coverage` is requested.
- Spurious warning for missing MM/ML tags when a BAM fails the coverage threshold

### Removed
- wf-basecalling subworkflow
    - fast5_dir input and other basecalling related options have been removed from the workflow parameters
    - Users should run the standalone wf-basecalling workflow and provide the output to wf-human-variation
- Mapula statistics with `--mapula`

## [v1.9.2]
### Fixed
- `--joint_phasing` generating single-chromosome VCF files.

## [v1.9.1]
### Changed
- ClinVar annotation of SVs has been temporarily removed due to not being correctly incorporated. SnpEff annotations are still produced as part of the final SV VCF.
- New documentation
### Removed
- `--annotation_threads` parameter, as the SnpEff process does not support multithreading.
### Fixed
- Truncated SV VCF header generated from `vcfsort`.
- `sed` crashing with I/O error in some instances.
- Missing flagstats file in output directory.


## [v1.9.0]
### Added
- STR workflow report now includes additional plots which display repeat units and interruptions in each supporting read
- CNV workflow now outputs an indexed VCF file to the output directory
### Changed
- Legend symbols in STR genotpying plot
- Unambiguous naming of bedMethyl files generated with `--mod`
    - Unphased outputs will have the pattern `[sample_name].wf_mods.bedmethyl.gz`
    - Phased outputs will have the pattern `[sample_name]_[1|2|ungrouped].wf_mods.bedmethyl.gz`
### Fixed
- Report step failing if bcftools stats file has only some sub-sections
- Clair3 ignoring the bed file
- merge_haplotagged_contigs incorrectly generating intermediate CRAM when input is BAM
- STR content generation failing due to forward slash in disease name in `variant_catalog_hg38.json`
- Report name for the read alignment statistics now follows the pattern `[sample_name].wf-human-alignment-report.html`

## [v1.8.3]
### Fixed
- configure-jbrowse breaking on unescaped spaces

## [v1.8.2]
### Added
- The SNP workflow will filter the final VCF to only return calls in the regions specified with `--bed`
    - Avoid clair3 calling variants in regions that flank those specified in the BED
- Add a process to sanitise BED files
### Fixed
- SNP subworkflow was ignoring BED file and analysing all regions
- Report SV crashing when generating the size plots with only large indels
- Downsampling not working when targeting regions with `--bed`
- `--phase_mod` not emitting the haplotagged bam files
- Report crashing when loading a clinvar-annotated VCF file with multiple `GENEINFO`/`CLNVC` entries
### Removed
- Default local executor CPU and RAM limits

## [v1.8.1]
### Fixed
- SV size barchart causing extremely large reports.
    - The plot has been replaced with a distribution plot fixed to +/- 5KBp. The summary table reports the INS and DEL min/max values.
- Workflow could not be launched from EPI2ME desktop app due to incorrectly quoted fields in schema

## [v1.8.0]
### Changed
- replaced `--methyl` with `--mod`, and `--phase_methyl` with `--phase_mod`
- replaced `modbam2bed` with `modkit` (v0.1.12)
- `--phase_mod` will generate three bed files, one for each haplotype and one for the reads that are not tagged.

### Added
- Add locus for *LRP12* to BED file of STR repeats (GRCh38)

## [v1.7.2]
### Changed
- When `--bed` and `--bam_min_coverage` are specified, the workflow will process the regions passing the coverage filters
- `whatshap` v2.0 in base workflow
### Fixed
- Patch `whatshap stats` crashing when no heterozygote sites are found in a contig
- Patch `makeReport` crashing when loading empty ClinVar VCFs

## [v1.7.1]
### Changed
- Increased minimum memory required for the workflow to 16 GB of RAM to reduce alignment failures
### Fixed
- sv.filterBam missing output file when creating BAM CSI

## [v1.7.0]
### Changed
- VCFs generated by the `--sv` option are now automatically annotated with `SnpEff`, incorporating ClinVar annotations
    - This can be switched off with `--skip_annotation`
- `—-skip_annotation` disables attempt to determine human genome version, enabling `--snp`, `--sv` and `--phase_methyl` to be called on genomes which aren’t hg19 or hg38 
- Updated example command displayed when running `--help`
- The ClinVar table in `--snp` and `--sv` reports is now sorted according to clinical significance, and includes HGVS cDNA and protein descriptions
- Workflow options for disabling steps have been updated for consistency:
    - `--skip_annotation` is now `--annotation false`
    - `--skip_refine_snp_with_sv` is now `--refine_snp_with_sv false`
- `--phase_methyl` also calls modifications using all reads to account for unphased regions
- `Input options` and `Output options` have been combined in the `Main options` category
- Updated Clair3 to v1.0.4
- SV workflow does not filter the SV calls by size and type
- Report for bam files failing the depth threshold is now consistent with the report of bam passing the hard threshold
- Perform Sniffles SV phasing with `--phase_sv`
- `--phase_vcf` now run Sniffles SV in phasing mode

### Fixed
- 'mosdepth_downsampled' is defined more than once warning
- Workflow crashing when providing a reference with spaces/brackets in file name
- Workflow not emitting GVCF even when requested
- GVCF sample name not matching `sample_name`
- `--cnv` subworkflow sometimes reporting incorrect genetic sex, due to the way segment copy numbers were aggregated across chromosomes

### Added
- Add downsampling of large bam files
- `--joint_phasing` allows an additional joint SNP and SV phasing
- `--joint_phasing` and `--phase_vcf` now emit a phased block GTF file to facilitate visualization

### Removed
- `--sv_types`, all SV types are returned without filtering
- `--max_sv_length`, all SVs are returned regardless of maximum size

## [v1.6.1]
### Changed
- GPU tasks are limited to run in serial by default to avoid memory errors
    - Users in cluster and cloud environments where GPU devices are scheduled must use `-profile discrete_gpus` to parallelise GPU work
    - A warning will be printed if the workflow detects it is running non-local execution but the discrete_gpus profile is not enabled
    - Additional guidance on GPU support is provided in our Quickstart
### Fixed
- ModuleNotFoundError on callCNV step when transforming some VCFs
- Malformed VCF created by annotation step if Java emits a warning

## [v1.6.0]
### Changed
- VCFs generated by the `--snp` option are now automatically annotated with `SnpEff`, incorporating ClinVar annotations
    - This can be switched off with `--skip_annotation`
- Bumped minimum required Nextflow version to 22.10.8
- Updated wf-basecalling subworkflow to 0.7.1 (Dorado 0.3.0)
- Enum choices are enumerated in the `--help` output
- Enum choices are enumerated as part of the error message when a user has selected an invalid choice
- Made it easier to see which basecaller configurations can be used for basecalling and which configurations are presented to allow small variant calling of existing datasets
    - Basecaller configurations prefixed with `clair3:` cannot be used for basecalling

### Added
- v4.2.0 basecalling models, which must be used for sequencing runs performed at new 5 kHz sampling rate
- v4.1.0 basecalling models replace v4.0.0 models and must be used for sequencing runs performed at 4 kHz sampling rate
- Clair3 260bps models

### Fixed
- Workflow `get_filter_calls_command` crashes with stranded interval BED
- CRAM inputs are now converted internally to BAM to avoid CNV subworkflow crash
- Basecalls and alignments are emitted in BAM to support CNV subworkflow if selected
- Workflow incorrectly prompting for an `--old_ref` when providing unaligned CRAM

## [v1.5.2]
### Added
- Configuration for running demo data in AWS

### Changed
- Reports for wf-human-sv and wf-human-snp

### Fixed
- Coverage plot not working when a bed region file is provided
- Workflow crashing with `--bam_min_coverage 0`
- Subworkflows that require hg19/GRCh37 now correctly accept references where chromosome sequence names do not have the 'chr' prefix

## [v1.5.1]
### Changed
- Depth of sequencing plots moved to alignment report

### Fixed
- Corrected bin size unit displayed on CNV report

## [v1.5.0]
### Added
- Workflow outputs alignment statistics report when alignment has been performed

### Changed
- Updated Clair3 to v1.0.1 to bump WhatsHap dependency to v1.7
- Bumped base container to use samtools 1.17 to prevent user reported segfault during minimap2_ubam process

## [v1.4.0]
### Added
- `--depth_intervals` will output a bedGraph file with entries for each genomic interval featuring homogeneous depth
- `--phase_methyl` will output haplotype-level methylation calls, using the HP tags added by whatshap in the wf-human-snp workflow
- `--sv_benchmark` will benchmark SV calls with Truvari
    - The workflow uses the 'NIST_SVs_Integration_v0.6' truth set and benchmarking should be carried out on HG002 data.

### Changed
- Added coverage barrier to wf-human-variation
- When the SNP and SV subworkflows are both selected, the workflow will use the results of the SV subworkflow to refine the SNP calls
    - This new behaviour can be disabled with `--skip_refine_snp_with_sv`
- Updated to Oxford Nanopore Technologies PLC. Public License
- Workflow requires target regions to have 20x mean coverage to permit analysis

### Fixed
- `report_sv.py` now handles empty VCF files
- `report_str.py` now handles mono-allelic STR
- WhatsHap processes do not block for long time with CRAM inputs due to missing REF_PATH
- filterCalls failure when input BED has more than three columns
- get_genome assumed STR subworkflow was always enabled, preventing CNV analysis with hg19
- "genome build (...) is not compatible with this workflow" was incorrectly thrown when the workflow stopped before calling get_genome

## [v1.3.0]
### Added
- `--str` enables STR genotyping using Straglr (compatible with genome build 38 only)

### Changed
- Minor performance improvement when checking for empty VCF in aggregate pileup steps

## [v1.2.0]
### Added
- `--cnv` enables CNV calling using QDNAseq

## [v1.1.0]
### Changed
- Updated Dorado container image to use Dorado v0.1.1
    - Latest models are now v4.0.0
    - Workflow prints a more helpful error when Dorado fails due to unknown model name
- Updated wf-human-snp container image to load new Clair3 models for v4 basecalling
- Default `basecaller_cfg` set to `dna_r10.4.1_e8.2_400bps_sup@v4.0.0`

### Added
- `--basecaller_args` may be used to provide custom arguments to the basecalling process

## [v1.0.1]
### Changed
- Default `basecaller_cfg` set to `dna_r10.4.1_e8.2_400bps_sup@v3.5.2`
- Updated description in manifest

## [v1.0.0]
### Added
- `nextflow run epi2me-labs/wf-human-variation --version` will now print the workflow version number and exit

### Changed
- `--modbam2bed_args` can be used to further configure the wf-methylation `modbam2bed` process
- `modbam2bed` outputs are now prefixed with `<sample_name>.methyl`
- `--basecall_cfg` is now required by the SNP calling subworkflow to automatically pick a suitable Clair3 model
    - Users no longer have to provide `--model` for the SNP calling subworkflow
- Tidied workflow parameter schema
    - Some advanced options that are primarily used for benchmarking are now hidden but can be listed with `--help --show_hidden_params`
- wf-basecalling subworkflow now separates reads into pass and fail CRAMs based on mean qscore
    - The workflow will index and align both the pass and fail reads and provide a CRAM for each in the output directory
    - Only pass reads are used for downstream variant calling
- Updated wf-human-variation-snp container to use Sniffles v2.0.7

### Removed
- `-profile conda` is no longer supported, users should use `-profile standard` (Docker) or `-profile singularity` instead
- `--report_name` is no longer required and reports will be prefixed with `--sample_name` instead

### Fixed
- Workflow will exit with "No files match pattern" if no suitable files are found to basecall
    - Ensure to set `--dorado_ext` to `fast5` or `pod5` as appropriate

## [v0.4.1]
### Fixed
- JBrowse2 configuration failed to load AlignmentTrack for CRAM output

## [v0.4.0]
### Added
- Workflow will now output a JBrowse2 `jbrowse.json` configuration
- Workflow reports will be visible in the Nextflow Tower reports tab

### Changed
- wf-basecalling 0.0.1 has been integrated to wf-human-variation
    - Basecalling is now conducted with Dorado
    - Basecalling options have changed, users are advised to check the basecalling options in `--help` for guidance
- GPU accelerated processes can now have their process directives generically modified in downstream user profiles using `withLabel:gpu`
- `mapula` will no longer run by default due to performance issues on large data sets and must be enabled with `--mapula`
    - This step will be deprecated and replaced with an equivalent in a future release

### Fixed
- uBAM input no longer requires an index
- CRAM is written to the output directory in all cases where alignment was completed

## [v0.3.1]
### Fixed
- `check_for_alignment` did not support uBAM
- Set `PYTHONNOUSERSITE` to reduce risk of environment bleed

## [v0.3.0]
### Added
- Experimental guppy subworkflow
    - We do not provide a Docker container for Guppy at this time, users will need to override `process.withLabel:wf_guppy.container`

### Changed
- `--ubam` option removed, users can now pass unaligned or aligned BAM (or CRAM) to `--bam`
    - If the input BAM is aligned and the provided `--ref` does not match the SQ lines (exact match to name and size) the file will be realigned to `--ref`
    - If the input CRAM is aligned and the provided `--ref` does not match the SQ lines (exact match to name and size) the file will be realigned to `--ref`, but will also require the old reference to be provided with `--old_ref` to avoid reference lookups
    - If the input is not aligned, the file will be aligned to `--ref`

### Fixed
- Chunks without variants will no longer terminate the workflow at the `create_candidates` step

## [v0.2.3]
### Added
- [`mapula`](https://github.com/epi2me-labs/mapula) used to generate basic alignment QC statistics in both CSV and JSON

### Changed
- Updated Clair3 to 0.1.12 (build 6) which bundles Longphase 1.3 to enable CRAM support and small improvement to accuracy
- `mosdepth` artifacts are now written to the output directory
    - Additionally outputs read counts at 1,10,20,30X coverage thresholds for each region in the input BAM (or each sequence of the reference if no BED is provided)
- Simplified `wf-human-sv` Docker image and conda definition

### Fixed
- Outdated conda environment definitions
- Docker based profiles no longer requires an internet connection to fetch the `cram_cache` cache building script

## [v0.2.2]
### Fixed
- "No such property" when using the `minimap2_ubam` alignment step
- Slow performance on `minimap2_ubam` step when providing CRAM as `--ubam`
- Slow performance on `snp:readStats` process

### Removed
- "Missing reference index" warning was unnecessary

## [v0.2.0]
### Added
- An experimental methylation subworkflow has been integrated, using [`modbam2bed`](https://github.com/epi2me-labs/modbam2bed) to aggregate modified base counts (input BAM should have `MM` and `ML` tags), enable this with `--methyl`

### Changed
- Workflow experimentally supports CRAM as input, uBAM input uses CRAM for intermediate files
- Reference FAI is now created if it does not exist, rather than raising an error
- `--sniffles_args` may be used to provide custom arguments to the `sniffles2` process
- Output files are uniformly prefixed with `--sample_name`
- Output alignment from `--ubam` is now CRAM formatted

### Fixed
- Existence of Clair3 model directory is checked before starting workflow
- `--GVCF` and `--include_all_ctgs` are correctly typed as booleans
    - `--GVCF` now outputs GVCF files to the output directory as intended
    - `--include_all_ctgs` no longer needs to be set as `--include_all_ctgs y`

## [v0.1.1]
### Added
- `--ubam_bam2fq_threads` and `--ubam_sort_threads` allow finer control over the resourcing of the alignment step
    - The number of CPU required for `minimap2_ubam` is sum(`ubam_bam2fq_threads`, `ubam_map_threads`, `ubam_sort_threads`)

### Changed
- `--ubam_threads` is now `--ubam_map_threads` and only sets the threads for the mapping specifically
- `--ref` is now required by the schema, preventing obscure errors when it is not provided
- Print helpful warning if neither `--snp` or `--sv` have been specified
- Fastqingress metadata map
- Disable dag creation by default to suppress graphviz warning

### Fixed
- Tandem repeat BED is now correctly set by `--tr_bed`
- Update `fastcat` dependency to 0.4.11 to catch cases where input FASTQ cannot be read
- Sanitize fastq intermittent null object error

### Note
- Switched to "new flavour" CI, meaning that containers are released from workflows independently

## [v0.1.0]
### Added
- Ported wf-human-snp (v0.3.2) to modules/wf-human-snp
- Ported wf-human-sv (v0.1.0) to modules/wf-human-sv

## [v0.0.0]
* Initialised wf-human-variation from wf-template #195cab5

