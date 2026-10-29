# Contributing

This repo is a two-person reproducibility study. This document covers how we work in it day-to-day — branching, pull requests, review, and code quality checks. For how to actually set up the environment and run the analysis, see `SETUP.md`.

## Branching model

This repo uses three persistent branches rather than short-lived feature branches:

- **`chantera`** — Chantera's independent, full working branch. All of her reproduction attempts, experiments, and iterations live here, including anything not ultimately chosen for `shared`.
- **`vy`** — Vy's independent, full working branch, same idea.
- **`shared`** — the curated, agreed-upon version. Only figures/analyses that have been independently attempted by both of us, compared, and jointly decided on get pulled in here.
- **`main`** — reflects the current state of `shared` once reviewed and merged.

### Why three branches instead of per-task branches
- Each person's branch is a complete, standalone record of their own independent reproduction — including work that doesn't end up in `shared`. This is intentional: it's real, attributable evidence of individual work (useful for anyone reviewing this repo as a portfolio piece, not just as a finished output).
- `shared` stays clean and only reflects jointly-reviewed, agreed-upon work.

### How work moves from an individual branch into `shared`
1. Work happens freely on your own branch (`chantera` or `vy`) — push directly, no PR needed between you and your own branch.
2. Once both people have independently attempted a given figure, compare results (see `comparison/` notes — each person's own branch holds their individual comparison notes; `shared` holds the joint, reconciled version once agreed).
3. Bring the chosen figure's work into `shared` via either:
   - **Cherry-pick** specific commit(s) from the individual branch onto `shared`, or
   - **A scoped PR** from the individual branch into `shared`, containing only the relevant figure's files.
4. This requires 1 approval (from the other collaborator) before merging into `shared`.
5. `shared` → `main` follows the same PR + approval process once the figure/phase is ready to be reflected as the repo's current state.

### What doesn't get cherry-picked stays exactly where it is
Nothing is "used up" or removed from an individual branch by being merged into `shared` — `chantera` and `vy` retain their full, unedited history regardless of what does or doesn't make it into `shared`. These branches are never deleted.

## Project structure

main ← mirrors current state of shared
shared ← curated, jointly-reviewed work
chantera ← Chantera’s full independent branch
vy ← Vy’s full independent branch


On `main`/`shared`, accepted work is organized as:

figures/
comparison/ ← joint, reconciled comparison notes
phase2-critique/
docs/
├── SETUP.md
├── methods-notes.md
└── data-access.md
CONTRIBUTING.md
README.md
pyproject.toml
.lintr
.pre-commit-config.yaml
environment.yml
.github/
└── workflows/
└── lint.yml

## Pull requests

- Every change to `main` goes through a PR — direct pushes to `main` are blocked by branch protection.
- Fill out the PR template (checklist for which figure/analysis is affected, whether output matches or a discrepancy is filed).
- **Requires 1 approval** before merging — we review each other's work, since part of the point of this project is practicing real research workflow, not just producing output.
- **All review conversations must be resolved** before merging.
- **CI must pass** (see Linting below) before merging.

## Issues

We use GitHub Issues to track:
- Setup/environment/data blockers (`setup-blocker.md` template)
- Figure reproduction discrepancies (`figure-discrepancy.md` template)
- Independent comparison results between our two reproductions (`independent-comparison.md` template)

Use the relevant template rather than a blank issue where one applies — it keeps the discrepancy/comparison log consistent and easy to scan later.

## Linting

CI automatically lints every PR via GitHub Actions (`.github/workflows/lint.yml`) using a fresh install of ruff (Python) and lintr/styler (R). You don't need anything installed locally for CI to catch lint issues — it runs automatically and must pass before a PR can merge.

### Optional: running lint checks locally before committing

If you'd like lint checks to run locally *before* you commit (so you catch issues immediately instead of waiting on CI), set up pre-commit:

**One-time setup:**
```bash
pip install pre-commit ruff
pre-commit install
```

For R checks (lintr, styler), make sure these are installed in your local R environment:
```r
install.packages(c("lintr", "styler"))
```

Once installed, every `git commit` automatically runs ruff, lintr, and styler against your staged files. A failing check blocks the commit until it's fixed (ruff and styler can often auto-fix — just re-stage the fixed files and commit again).

### Running checks manually (without committing)
```bash
# Python
ruff check .
ruff format .

# R
Rscript -e "lintr::lint_dir('.')"
Rscript -e "styler::style_dir('.')"
```

This local setup is entirely optional — CI will catch everything regardless.

## Style conventions

- **Python:** follows ruff's defaults (see `pyproject.toml` for exact rule selection).
- **R:** follows tidyverse style conventions via `styler` (the default — no custom config).

## Commit messages

Keep them short and descriptive — what changed, not how. E.g., `Add QC filtering for Figure 2 clustering`, not `updates`.

## Questions or blockers

If you're stuck on something environment- or data-related, check `SETUP.md` first, then open a `setup-blocker` issue rather than troubleshooting silently — it keeps a record of what was hard and how it got resolved, which is useful for the reproducibility write-up itself.