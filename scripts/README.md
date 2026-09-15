# `scripts/`

The analysis pipeline. Numbered scripts, run in order, each reading parameters from
[`config/`](../config) and writing to [`data/processed/`](../data), [`results/`](../results), and
[`figures/`](../figures).

## Planned order

| Script | Purpose | Tools |
|---|---|---|
| `00_install_packages.R` | Install/pin every dependency (R and Python) | — |
| `01_download_data.sh` | Fetch GEO / Zenodo / TCGA inputs into `data/raw/` | — |
| `02_scrna_qc.R` | scRNA-seq QC, normalization, integration, clustering, annotation | Seurat v4.3.0 |
| `03_spatial.R` | Visium processing, resolution enhancement, scRNA/ST mapping, super-resolution | Seurat, BayesSpace v1.6.0, CellTrek, iStar |
| `04_trajectory.R` | CD8+ T cell pseudotime trajectory | Monocle2 v2.26.0 |
| `05_cellchat.R` | Cell-cell communication + validation | CellChat v1.6.1, CellPhoneDB v4.0.0, iTALK |
| `06_epithelial_crosstalk.R` | Epithelial ligand-receptor analysis (ANXA1-FPR1/3, MDK-LRP1) | CellChat, ReactomePA v1.42.0 |
| `07_tcga_scoring.R` | Bulk RNA-seq gene set activity, deconvolution, stromal/immune scores | AUCell v1.20.2, CIBERSORT, ESTIMATE |
| `08_ers_model.R` | ERS signature: Cox + LASSO, KM/ROC/calibration/DCA, validation cohorts | glmnet, survival |

Filenames will shift as the pipeline is built; this table is the intended shape, not a contract.

## Conventions

- **Numbered and ordered.** A script may depend only on outputs of lower-numbered scripts, so the
  pipeline runs top to bottom from a clean clone.
- **No hardcoded parameters.** Thresholds, resolutions, and paths come from [`config/`](../config).
- **Set a seed** in anything stochastic (UMAP, clustering, LASSO CV) and record it in config.
- **Paths are repo-relative**, never absolute — nothing tied to one person's machine.
- **Cite the methods section.** Where the paper specifies a value, note it in a comment; where it
  does not and we had to choose, say so explicitly — those judgment calls are the main output of
  this reproduction.
- New dependencies get added to `00_install_packages.R` in the same PR.
