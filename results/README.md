# `results/`

Tabular and numeric output — the quantitative results of the pipeline, in forms that can be read,
diffed, and compared against the numbers reported in Su et al. 2025.

## What belongs here

- **Cell-level summaries** — per-sample cell counts before/after QC, cluster sizes, cell type
  proportions by HPV status.
- **Marker and differential expression tables** — cluster markers, HPV+ vs HPV− DE genes.
- **Enrichment output** — ReactomePA / pathway enrichment tables, AUCell score matrices.
- **Cell-cell communication tables** — CellChat / CellPhoneDB / iTALK significant
  ligand-receptor pairs and interaction strengths.
- **Deconvolution and scoring** — CIBERSORT fractions, ESTIMATE stromal/immune scores.
- **Prognostic model output** — LASSO-selected genes and coefficients, risk scores, Cox model
  summaries, KM log-rank statistics, time-dependent AUCs.
- **Comparison tables** — our value vs the paper's reported value, with the delta, for anything
  the paper states numerically.

## Conventions

- Prefer `.csv`/`.tsv` so results are diffable in review; large serialized objects belong in
  `data/processed/`.
- Prefix files with the producing script's number (`04_cellchat_lr_pairs.csv` ←
  `scripts/04_cellchat.R`) so provenance is obvious.
- Small result tables are **committed** — they are the record of what we actually got, and how it
  changed as the pipeline was corrected.
- Figures built from these tables live in [`figures/`](../figures).
