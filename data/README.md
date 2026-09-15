# `data/`

Raw and intermediate data for the reproduction. **This directory is intentionally empty in git** —
the contents are ignored by `.gitignore` because single-cell and spatial objects are far too large
to version. This README is the manifest: it records what should be here, so anyone cloning the repo
can rebuild the directory from public sources.

## Why nothing is committed

All inputs are publicly available (GEO, Zenodo, TCGA), and the derived objects (`.rds`, `.h5`,
`.h5ad`) run from hundreds of MB to several GB. We track the *recipe*, not the bytes.

## Expected contents

| Dataset | Accession / source | Assay | Lineage / scope | Approx. size | Status |
|---|---|---|---|---|---|
| scRNA-seq, cervical squamous cell carcinoma | [GSE171894](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE171894) | 10x scRNA-seq | 4 CSCC samples (2 HPV+, 2 HPV−); epithelial, T/NK, myeloid, fibroblast, endothelial, B/plasma | TBD | ⬜ not verified |
| Spatial transcriptomics | [Zenodo 10.5281/zenodo.16917924](https://doi.org/10.5281/zenodo.16917924) | 10x Visium | Matched CSCC sections; H&E + spot-level counts | TBD | ⬜ not downloaded |
| Bulk RNA-seq (model training) | TCGA-CESC | Bulk RNA-seq + clinical | 269 HPV+ patients | TBD | ⬜ not downloaded |
| Independent validation cohort | [GSE52903](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE52903) | Microarray/bulk | 55 HPV+ patients | TBD | ⬜ not downloaded |
| Immunotherapy response cohort | PRJEB25780 | Bulk RNA-seq | Metastatic gastric cancer, pembrolizumab | TBD | ⬜ not downloaded |

> ⚠️ `GSE171894` is an unusually early-numbered accession for a 2025 paper. Verify sample count,
> HPV status labels, and file types against the GEO record before building the pipeline on it.

## Layout

```
data/
├── raw/          # untouched downloads, exactly as retrieved (never edited in place)
├── processed/    # filtered/normalized Seurat & spatial objects written by scripts/
└── external/     # reference files: gene sets, CellChat/CellPhoneDB DBs, signature gene lists
```

## Conventions

- Record for every dataset: **name, accession, file size, checksum, download date, and the
  specific lineage/cell populations** it covers — fill in the table above as items land.
- `raw/` is read-only once downloaded. All transformations write to `processed/`.
- Anything reproducible from a script does not need re-downloading — note which script produces it.
