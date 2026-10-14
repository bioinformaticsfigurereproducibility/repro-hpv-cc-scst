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

# 5. Install BayesSpace 1.6.0 from source (Bioconductor 3.15)
# Not available on bioconda; its dependencies are installed via env.yaml
# Reference: https://bioconductor.org/packages/3.15/bioc/html/BayesSpace.html
RUN Rscript -e 'install.packages("https://bioconductor.org/packages/3.15/bioc/src/contrib/BayesSpace_1.6.0.tar.gz", repos = NULL, type = "source")' && \
    Rscript -e 'library(BayesSpace); stopifnot(packageVersion("BayesSpace") == "1.6.0")'
