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

# a. Install BayesSpace 1.6.0 from source (Bioconductor 3.15)
# Available on bioconductor only; its dependencies are installed via env.yaml
# Reference: https://bioconductor.org/packages/3.15/bioc/html/BayesSpace.html
RUN Rscript -e 'install.packages("https://bioconductor.org/packages/3.15/bioc/src/contrib/BayesSpace_1.6.0.tar.gz", repos = NULL, type = "source")' && \
    Rscript -e 'library(BayesSpace); stopifnot(packageVersion("BayesSpace") == "1.6.0")'

# b. Install CellTrek (Version Unknown)
# Reference: https://github.com/navinlabcode/CellTrek
# remotes installs package for remote resources like github https://remotes.r-lib.org/reference/install_github.html
# To get b8059... go to # commits and copy the commit you want to version
# upgrade = never does not upgrade CellTrek's dependencies already listed in env
# dependencies = false applies to dependencies missing from the env. It does not download dependencies using
# install_github, instead error thrown
# This is used so env can have full control of dependencies and version control
RUN Rscript -e 'remotes::install_github("navinlabcode/CellTrek@b80590e5dddcf7076c9f88c935ff2629a963d5b2", upgrade = "never", dependencies = FALSE)' && \
    Rscript -e 'library(CellTrek)'

# c. Install iStar (Version Unknown)
# Reference: https://github.com/daviddaiweizhang/istar

# d. Install CellChat 1.6.1
# Reference: https://github.com/sqjin/CellChat

# e. Install CellPhoneDB (Version Unknown)
# Reference: https://github.com/ventolab/CellphoneDB

# f. Install iTALK (Version Unknown)
# Reference: https://github.com/Coolgenome/iTALK

# g. Install AUCell 1.20.2 from source (Bioconductor 3.16)
# Available on bioconductor only; its dependencies are installed via env.yaml
# Reference: https://bioconductor.org/packages/3.16/bioc/html/AUCell.html
RUN Rscript -e 'install.packages("https://bioconductor.org/packages/3.16/bioc/src/contrib/AUCell_1.20.2.tar.gz", repos = NULL, type = "source")' && \
    Rscript -e 'library(AUCell); stopifnot(packageVersion("AUCell") == "1.20.2")'

