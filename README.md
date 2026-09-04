# ATDILI Pharmacogenomics

Reproducible computational workflows for pharmacogenomic analysis of
anti-tuberculosis drug-induced liver injury (ATDILI).

## Overview

This repository contains the computational workflows developed for the
pharmacogenomic analysis performed as part of the PhD study of
anti-tuberculosis drug-induced liver injury.

The workflow includes:

- VCF merging and processing
- Variant normalization
- Variant quality filtering
- Allele-frequency analysis
- Ensembl VEP annotation
- Gene-panel filtering
- Pharmacogene chromosome phasing
- Star-allele/diplotype assignment
- Quality-control analyses
- Investigation of potentially novel or unresolved alleles

## Workflow

```text
DRAGEN hard-filtered VCFs
            |
            v
       VCF merging
            |
            v
   Variant normalization
            |
            v
      Quality filtering
            |
            v
       PASS variants
            |
            +----------------------+
            |                      |
            v                      v
    Allele frequencies       VEP annotation
                                   |
                                   v
                           Gene-panel filtering
                                   |
                                   v
                         Chromosome-level phasing
                                   |
                                   v
                         Star-allele assignment
                                   |
                                   v
                            Diplotype calling
