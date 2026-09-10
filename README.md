# Reproducing: HPV-Associated Immune Microenvironment Heterogeneity in Cervical Cancer

Reproducibility study rebuilding the bioinformatics pipeline and figures from Su et al. 2025 (*Front Immunol*) — an integrated scRNA-seq/spatial transcriptomics/bulk RNA-seq analysis of HPV-associated immune microenvironment heterogeneity in cervical cancer.

## Source Publication

**Citation:**
Su Q, Tian X, Li F, Yu X, Gong W, Chen Y, Wang J, Yang S, Zhang S, Zhang Q, Yang S. "Integrated multi-omics analysis of single-cell and spatial transcriptomics reveals distinct HPV-associated immune microenvironment features and prognostic signatures in cervical cancer." *Front Immunol.* 2025 Sep 16;16:1612623. doi: [10.3389/fimmu.2025.1612623](https://doi.org/10.3389/fimmu.2025.1612623). PMID: 41035636, PMCID: [PMC12481161](https://pmc.ncbi.nlm.nih.gov/articles/PMC12481161/).

**Abstract summary:** The study analyzed scRNA-seq and spatial transcriptomics (10x Visium) data from four cervical squamous cell carcinoma samples (2 HPV-positive, 2 HPV-negative), integrated with bulk RNA-seq (TCGA-CESC), to characterize immune cell subtypes, their spatial distribution, and cell-cell communication patterns differing by HPV status. The study also derives an epithelial cell-related risk signature (ERS) with prognostic value in HPV-positive cervical cancer.

## Scope of This Reproduction

This repository focuses solely on the **computational/bioinformatics analysis pipeline** — not sample collection, wet-lab procedures, or multiplex immunofluorescence validation. The goal is to reconstruct the paper's published figures from available data and methods, and to document where the reproduction succeeds, diverges, or requires judgment calls not fully specified in the original methods.

## Data Availability

Per the original paper's Data Availability Statement:

- **scRNA-seq data:** deposited in GEO, accession [**GSE171894**](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE171894)
- **Spatial transcriptomics data:** deposited in Zenodo, accession [**10.5281/zenodo.16917924**](https://doi.org/10.5281/zenodo.16917924)
- **Bulk RNA-seq / prognostic model training set:** TCGA-CESC (269 HPV-positive patients)
- **Independent validation cohort:** GSE52903 (55 HPV-positive patients)
- **Immunotherapy response cohort:** PRJEB25780 (metastatic gastric cancer, pembrolizumab)

> ⚠️ **Note:** GSE171894 is an unusually early-numbered GEO accession for a 2025 publication. This should be verified directly against the GEO record (sample count, HPV status labels, file types) before building the pipeline around it, in case it reflects a reused/linked dataset or a transcription error in the published accession.

## Methods & Tooling to Reproduce

| Analysis step | Tool(s) | Version |
|---|---|---|
| scRNA-seq QC, normalization, clustering | Seurat | v4.3.0 (R v4.2.3) |
| Spatial transcriptomics processing | Seurat | v4.3.0 |
| Spatial resolution enhancement | BayesSpace | v1.6.0 |
| scRNA-seq / ST integration | CellTrek | — |
| Super-resolution tissue architecture | iStar | — |
| Pseudotime trajectory analysis | Monocle2 | v2.26.0 |
| Cell-cell communication | CellChat | v1.6.1 |
| Cell-cell communication (validation) | CellPhoneDB | v4.0.0 |
| Cell-cell communication (validation) | iTALK | — |
| Gene set activity scoring (TCGA) | AUCell | v1.20.2 |
| Pathway enrichment | ReactomePA | v1.42.0 |
| Immune deconvolution | CIBERSORT | — |
| Stromal/Immune scoring | ESTIMATE | — |
| Prognostic signature construction | Cox regression + LASSO (glmnet) | — |

## Figures to Reproduce

- **Figure 1:** Super-resolution tissue architecture (iStar) and spatial marker distribution in HPV+/HPV− CC
- **Figure 2:** Single-cell landscape — UMAP clustering, cell type proportions by HPV status
- **Figure 3:** CD8+ T cell pseudotime trajectory analysis (Monocle2)
- **Figure 4:** Cell-cell communication network analysis (CellChat/CellPhoneDB)
- **Figure 5:** Epithelial cell crosstalk, ligand-receptor analysis (ANXA1-FPR1/3, MDK-LRP1)
- **Figure 6:** Epithelial cell-related risk signature (ERS) construction and validation (LASSO, KM curves, ROC, calibration, DCA)

## Status

🚧 Setup phase — data access verification and environment setup in progress.

## Collaborators

- Chantera Lazard 
- Vy Dang
