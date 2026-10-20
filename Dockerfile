# 1. Choose a foundational base image
# I chose conda because this paper mixes python and R
# Reference: https://micromamba-docker.readthedocs.io/en/latest/
FROM mambaorg/micromamba:2.9.0

# 2. Copy the environment into the docker image
# Copy the yaml file into your docker image and then pass the yaml file as a parameter to micromamba via the --file switch
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml

# 3.  Install the conda environment
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

# 4. Activate the environment for the RUN commands
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# 5. Install dependencies not available on conda
# Order matters: dependencies installed from source must come before the packages that need them
# a. CRAN packages with no 4.2 build on conda-forge
# R 4.2.3 WAS RELEASED MARCH 15,2023. Paper was submitted April 25, 2025. Looking for latest version in that timeframe
# NMF is required by Cellchat; packcircles is required by Celltrek; leidenbase is required by monocole 2

# NMF 0.26 published 03/20/23 https://packagemanager.posit.co/client/#/repos/cran/packages/NMF/overview
RUN Rscript -e 'remotes::install_version("NMF", version = "0.26", repos = "https://cloud.r-project.org", upgrade = "never", dependencies = FALSE)' && \
    Rscript -e 'library(NMF); stopifnot(packageVersion("NMF") == "0.26")'

# packcircles 0.3.5 published 11/22/22 https://packagemanager.posit.co/client/#/repos/cran/packages/packcircles/overview
RUN Rscript -e 'remotes::install_version("packcircles", version = "0.3.5", repos = "https://cloud.r-project.org", upgrade = "never", dependencies = FALSE)' && \
    Rscript -e 'library(packcircles); stopifnot(packageVersion("packcircles") == "0.3.5")'

# leidenbase 0.1.18 published 04/15/2023 https://packagemanager.posit.co/client/#/repos/cran/packages/leidenbase/versions
RUN Rscript -e 'remotes::install_version("leidenbase", version = "0.1.18", repos = "https://cloud.r-project.org", upgrade = "never", dependencies = FALSE)' && \
    Rscript -e 'library(leidenbase); stopifnot(packageVersion("leidenbase") == "0.1.18")'

# b. Install BayesSpace 1.6.0 from source (Bioconductor 3.15)
# Available on bioconductor only; its dependencies are installed via env.yaml
# Reference: https://bioconductor.org/packages/3.15/bioc/html/BayesSpace.html
RUN Rscript -e 'install.packages("https://bioconductor.org/packages/3.15/bioc/src/contrib/BayesSpace_1.6.0.tar.gz", repos = NULL, type = "source")' && \
    Rscript -e 'library(BayesSpace); stopifnot(packageVersion("BayesSpace") == "1.6.0")'

# c. Install CellTrek (Version 0.0.94)
# Reference: https://github.com/navinlabcode/CellTrek
# remotes installs package for remote resources like github https://remotes.r-lib.org/reference/install_github.html
# To get b8059... go to # commits and copy the commit you want to version
# upgrade = never does not upgrade CellTrek's dependencies already listed in env
# dependencies = false applies to dependencies missing from the env. It does not download dependencies using
# install_github, instead error thrown
# This is used so env can have full control of dependencies and version control
RUN Rscript -e 'remotes::install_github("navinlabcode/CellTrek@b80590e5dddcf7076c9f88c935ff2629a963d5b2", upgrade = "never", dependencies = FALSE)' && \
    Rscript -e 'library(CellTrek); stopifnot(packageVersion("CellTrek") == "0.0.94")'


# d. Install CellChat 1.6.1
# Reference: https://github.com/sqjin/CellChat
RUN Rscript -e 'remotes::install_github("sqjin/CellChat@e4f68625b074247d619c2e488d33970cc531e17c", upgrade = "never", dependencies = FALSE)' && \
    Rscript -e 'library(CellChat); stopifnot(packageVersion("CellChat") == "1.6.1")'

# e. Install monocole 2.26.0 from source (Bioconductor 3.16) which requires leidenbase which is not compatible with R 4.2
# Reference: https://bioconductor.org/packages/3.16/bioc/html/monocle.html
RUN Rscript -e 'install.packages("https://bioconductor.org/packages/3.16/bioc/src/contrib/monocle_2.26.0.tar.gz", repos = NULL, type = "source")' && \
    Rscript -e 'library(monocle); stopifnot(packageVersion("monocle") == "2.26.0")'

# f. Install iTALK (Version 0.1.0)
# Reference: https://github.com/Coolgenome/iTALK
RUN Rscript -e 'remotes::install_github("Coolgenome/iTALK@6d9b3907f00004fcac9514d2726ad68d524a952b", upgrade = "never", dependencies = FALSE)' && \
    Rscript -e 'library(iTALK); stopifnot(packageVersion("iTALK") == "0.1.0")'

# g. Install AUCell 1.20.2 from source (Bioconductor 3.16)
# Available on bioconductor only; its dependencies are installed via env.yaml
# Reference: https://bioconductor.org/packages/3.16/bioc/html/AUCell.html
RUN Rscript -e 'install.packages("https://bioconductor.org/packages/3.16/bioc/src/contrib/AUCell_1.20.2.tar.gz", repos = NULL, type = "source")' && \
    Rscript -e 'library(AUCell); stopifnot(packageVersion("AUCell") == "1.20.2")'

# h. Install Estimate  (Version 1.0.13)
# Original Reference: https://bioinformatics.mdanderson.org/estimate/rpackage.html
# R-forge is the source but I cannot seem to connect to server, so will download using Github mirror
# Github Reference: https://github.com/r-forge/estimate/tree/master
RUN Rscript -e 'remotes::install_github("r-forge/estimate@abd60e4979c50a88407f7bfb9211687cb443abc6", subdir = "pkg/estimate", upgrade = "never", dependencies = FALSE)' && \
    Rscript -e 'library(estimate); stopifnot(packageVersion("estimate") == "1.0.13")'

# 6. Set the working directory where the repo will be mounted at runtime
WORKDIR /home/mambauser/repro-hpv-cc-scst

# 7. Image metadata
LABEL org.opencontainers.image.title="repro-hpv-cc-scst" \
      org.opencontainers.image.description="Analysis environment for reproducing Su et al. 2025, Front Immunol" \
      org.opencontainers.image.source="https://github.com/bioinformaticsfigurereproducibility/repro-hpv-cc-scst"