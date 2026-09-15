# `figures/`

Rendered visualizations — our reproduction attempts at the figures in Su et al. 2025, plus
diagnostic plots that never appear in the paper but are needed to judge whether a step worked.

## What belongs here

Plot outputs only: UMAPs, dot plots, heatmaps, violin/ridge plots, spatial feature and
super-resolution plots, pseudotime trajectories, CellChat circle/chord/bubble plots,
Kaplan–Meier curves, ROC, calibration, and DCA curves.

Numbers behind the plots (differential expression tables, cell counts, model coefficients) go in
[`results/`](../results) instead.

## Layout

```
figures/
├── figure1/   # Super-resolution tissue architecture (iStar), spatial markers HPV+/HPV−
├── figure2/   # Single-cell landscape: UMAP clustering, cell type proportions by HPV status
├── figure3/   # CD8+ T cell pseudotime trajectory (Monocle2)
├── figure4/   # Cell-cell communication networks (CellChat / CellPhoneDB)
├── figure5/   # Epithelial crosstalk, ligand-receptor (ANXA1-FPR1/3, MDK-LRP1)
├── figure6/   # ERS construction and validation (LASSO, KM, ROC, calibration, DCA)
└── qc/        # Diagnostics: violin QC plots, elbow/PCA, doublet scores, batch-effect checks
```

## Conventions

- Name panels after the paper: `figure2B_umap_celltypes.png` — makes side-by-side comparison
  against the publication straightforward.
- Save a vector version (`.pdf`/`.svg`) for anything destined for a write-up, plus a `.png` for
  quick viewing in PRs and issues.
- Every figure is written by a script in [`scripts/`](../scripts) — no hand-edited images, so the
  whole directory can be deleted and regenerated.
- When a panel does not match the paper, keep it and open an issue using the
  *reproduction discrepancy* template rather than deleting the evidence.
