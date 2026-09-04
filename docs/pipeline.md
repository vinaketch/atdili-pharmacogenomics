# ATDILI Pharmacogenomics Analysis Pipeline

## Overview

The computational workflow consisted of four major stages:

1. VCF processing
2. Variant annotation
3. Pharmacogene analysis
4. Quality control

## 1. VCF processing

Hard-filtered DRAGEN VCF files from the 286 study participants were
identified and symbolically linked into the analysis workspace.

The cohort VCFs were merged using bcftools with:

- `-m none`
- `-0`

The merged VCF was subsequently normalized using bcftools.

Duplicate variants were removed and multiallelic variants were split.

Variant filtering was performed using:

- QUAL >= 30
- alternate allele depth >= 15
- genotype filtering parameters `-g 8` and `-G 10`

Only variants classified as PASS were retained for downstream analysis.

## 2. Variant frequency analysis

Allele frequencies were calculated from the PASS-filtered cohort VCF
using vcftools.

## 3. Variant annotation

Variants were annotated using Ensembl Variant Effect Predictor (VEP).

The VEP output was filtered to retain MANE Select annotations and
subsequently restricted to genes represented in the study gene panel.

The presence and absence of panel genes in the resulting annotations
were assessed as a quality-control step.

## 4. Pharmacogene analysis

Pharmacogene analysis involved chromosome-level phasing followed by
allele-defining variant matching and diplotype assignment.

Beagle was used for phasing.

Where multiple pharmacogenes were located on the same chromosome, the
same phased chromosome-level VCF was reused.

Gene-specific allele-definition VCFs were compared with the phased cohort
VCF using bcftools isec.

Diplotypes were assigned using the StellarPGx workflow and associated
scripts.

## 5. Potential novel or unresolved alleles

Potentially novel or unresolved alleles were reviewed against the
corresponding pharmacogenomic database and PharmVar definitions.

Where required, variants identified through VEP, including
nonsynonymous variants, were reviewed to determine whether additional
variants could explain unresolved diplotype assignments.

## Reproducibility

The analysis scripts and configuration files are provided in this
repository.

Participant-level genomic data, clinical metadata and intermediate
analysis files are not included in the repository.
