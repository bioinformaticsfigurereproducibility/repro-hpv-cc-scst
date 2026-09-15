# `config/`

Configuration for the pipeline — everything that parameterizes a run without being code.

## What belongs here

- **Sample sheets / metadata** — sample IDs, HPV status (HPV+/HPV−), tissue site, which
  assay each sample came from (scRNA-seq, 10x Visium, bulk RNA-seq).
- **Analysis parameters** — QC thresholds (min/max features, percent mitochondrial), number of
  PCs, clustering resolution, `BayesSpace` enhancement settings, `Monocle2` ordering genes,
  `CellChat` database choice, LASSO/Cox settings for the ERS model.
- **Path / environment config** — where raw downloads live, output prefixes, seeds for
  reproducibility.
- **Tool-specific config files** — e.g. `CellPhoneDB` and `iStar` input configs.

## Conventions

- One file per analysis stage, named to match the script that reads it
  (`02_qc_params.yaml` ↔ `scripts/02_qc.R`).
- No hardcoded thresholds inside scripts — if a number could reasonably be changed, it lives here.
- Record the paper's stated value alongside ours whenever the two differ, so divergences from
  Su et al. 2025 are visible in version control rather than buried in a script.
- Config files are small and text-based, so they are **committed** (unlike `data/`).
