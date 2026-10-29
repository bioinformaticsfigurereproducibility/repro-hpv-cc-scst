# Environment Setup

## 1. Overview

This document explains how to set up the Docker environment used to reproduce our figures. We provide a pre-built Docker image containing the full pinned environment for reproducing Su et al. 2025, with R 4.2.3, Python 3.9, and the paper's stated package versions. Because the image is pre-built, most users can simply **pull** it rather than building it, and start the analysis right away.

---

## 2. Prerequisites

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
* Access to this GitHub repository (the image is private and inherits the repository's access)
* A GitHub **classic** personal access token with only the `read:packages` scope, used to log in to the container registry:
  * On GitHub, click your profile picture in the upper-right corner and go to **Settings**.
  * At the bottom of the left sidebar, click **Developer settings**, then **Personal access tokens** → **Tokens (classic)**.
  * Click **Generate new token (classic)**, select only `read:packages`, and set an expiration date.
  * Copy the token right away. GitHub only shows it once.

---

## 3. Log in and pull the image

```bash
docker login ghcr.io
docker pull --platform linux/amd64 ghcr.io/bioinformaticsfigurereproducibility/repro-hpv-cc-scst:latest
```

**Please read first:**

* When prompted, enter your GitHub username, and paste the **token** (not your GitHub password) as the password. You only need to log in once per machine.
* **Apple Silicon Macs:** the image is built for Intel/AMD (`linux/amd64`) only. Without `--platform linux/amd64`, Docker on an Apple Silicon Mac looks for an ARM version of the image and fails. With the flag, the image runs under emulation, and all packages load correctly.

---

## 4. Run the container

Run this from the **root of the repository**:

```bash
docker run -it --rm --platform linux/amd64 \
  -v "$(pwd)":/home/mambauser/repro-hpv-cc-scst \
  ghcr.io/bioinformaticsfigurereproducibility/repro-hpv-cc-scst:latest
```

* `-v` is **volume mounting**. It links the repository folder on your machine to `/home/mambauser/repro-hpv-cc-scst` inside the container. Scripts and data in the repo are available inside the container, outputs are saved back to your repo, and edits you make on your machine show up immediately.
* `--rm` is **auto-remove**. It deletes the container when you exit, so stopped containers don't pile up. The image itself stays, so the next run starts instantly.
* `-it` opens an interactive shell inside the container. From there you can run `R`, `Rscript`, or `cellphonedb`.
* Type `exit` (or press `Ctrl+D`) to leave the container.

---

## 5. Verify the environment

```bash
docker run --rm --platform linux/amd64 \
  -v "$(pwd)":/home/mambauser/repro-hpv-cc-scst \
  ghcr.io/bioinformaticsfigurereproducibility/repro-hpv-cc-scst:latest \
  Rscript tests/smoke_test.R
```

* Success shows `OK` for every package, followed by "All packages loaded at expected versions" and the full `sessionInfo()`.
* A message reporting about 40 warnings is expected and harmless. These are package startup notices, not failures.
* If any package fails, the test lists it under "SMOKE TEST FAILED" and exits with an error.

---

## 6. Manual step: CIBERSORT

CIBERSORT (used for immune cell deconvolution in Figure 6) is distributed under a license that does not allow redistribution, so its files are **not** included in the repository or the Docker image. Each user must obtain them separately:

1. Register for an account on the CIBERSORT website (cibersort.stanford.edu).
2. Download `CIBERSORT.R` and the `LM22.txt` signature matrix.
3. Place both files in `vendor/cibersort/` in your copy of the repository.

The `vendor/cibersort/` folder is listed in `.gitignore`, so these files are never committed. Because the repository is mounted into the container (see Section 4), the container can use them without the files being part of the image.

---

## 7. Building the image (maintainers only)

Most users never need to build the image. It is built automatically by GitHub Actions (`.github/workflows/docker-build.yml`) whenever `Dockerfile`, `env.yaml`, or the tests change. The workflow builds the image on an x86 Linux runner, runs the smoke test, and pushes the result to the GitHub Container Registry.

* **Building locally on Apple Silicon fails.** Some packages (for example, leidenbase) run compiled test programs during installation, and Docker's x86 emulation reports a lower CPU feature level than those programs require (`CPU ISA level is lower than required`). This only affects building. The finished image runs fine on Apple Silicon.
* **Version decisions** (pinned versions, deviations from the paper, and the reasoning behind them) are documented in the README's environment section. Exact installed versions are recorded in `env.lock.yaml` (conda packages) and `docs/session_info.txt` (all R packages).

---

## 8. Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `pull access denied ... may require 'docker login'` | Not logged in, or the image name is mistyped | Run `docker login ghcr.io` with your token, and check the image name |
| `no matching manifest for linux/arm64` | `--platform linux/amd64` is missing on an Apple Silicon Mac | Add `--platform linux/amd64` to the command |
| `Permission denied` when running a script | `Rscript` is missing from the command, so the shell tries to run the `.R` file directly | Add `Rscript` before the script path |
| `cannot open file ... No such file or directory` | The command wasn't run from the repository root, so the mount points to the wrong folder | `cd` to the repository root and rerun |