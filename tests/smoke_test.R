# ============================================================================
# Smoke test: confirm every analysis package loads in the Docker image,
# and that pinned packages are at their expected versions.
# Run inside the container: Rscript tests/smoke_test.R
# ============================================================================

# Packages with a version pinned in the Dockerfile or env.yaml
pinned <- c(
  Seurat      = "4.3.0",
  BayesSpace  = "1.6.0",
  AUCell      = "1.20.2",
  monocle     = "2.26.0",
  ReactomePA  = "1.42.0",
  CellChat    = "1.6.1",
  CellTrek    = "0.0.94",
  iTALK       = "0.1.0",
  estimate    = "1.0.13",
  NMF         = "0.26",
  packcircles = "0.3.6",
  leidenbase  = "0.1.18"
)

# Packages that only need to load (no version stated or pinned)
unpinned <- c("glmnet", "survival", "e1071", "preprocessCore")

failures <- character(0)

for (p in names(pinned)) {
  ok <- suppressPackageStartupMessages(requireNamespace(p, quietly = TRUE))
  if (!ok) {
    failures <- c(failures, sprintf("%s: not installed", p))
  } else if (as.character(packageVersion(p)) != pinned[[p]]) {
    failures <- c(failures, sprintf("%s: expected %s, found %s",
                                    p, pinned[[p]], packageVersion(p)))
  } else {
    message(sprintf("OK  %-12s %s", p, packageVersion(p)))
  }
}

for (p in unpinned) {
  if (suppressPackageStartupMessages(requireNamespace(p, quietly = TRUE))) {
    message(sprintf("OK  %-12s %s", p, packageVersion(p)))
  } else {
    failures <- c(failures, sprintf("%s: not installed", p))
  }
}

if (getRversion() != "4.2.3") {
  failures <- c(failures, sprintf("R: expected 4.2.3, found %s", getRversion()))
}

if (length(failures)) {
  message("\nSMOKE TEST FAILED:")
  message(paste(" -", failures, collapse = "\n"))
  quit(status = 1)
}

message("\nAll packages loaded at expected versions.")
sessionInfo()
