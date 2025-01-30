# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_IMAGE=$REGISTRY/$OWNER/pyspark-notebook
FROM $BASE_IMAGE

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# RSpark config
ENV R_LIBS_USER="${SPARK_HOME}/R/lib"
RUN fix-permissions "${R_LIBS_USER}"

# R pre-requisites
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# R packages including IRKernel which gets installed globally.
RUN mamba install --yes \
    'r-base' \
    'r-ggplot2' \
    'r-irkernel' \
    'r-rcurl' \
    'r-sparklyr' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"



### Pecanstreet modifications
# update conda
RUN conda update -n base conda
RUN /opt/conda/bin/pip3 install pandas matplotlib psycopg2-binary bash_kernel

# install bash kernel
RUN python3 -m bash_kernel.install

# c kernel
# RUN pip3 install jupyter-c-kernel && install_c_kernel

# c++ xeus kernel
#RUN conda install --yes -c conda-forge xeus-cling
RUN mamba create -n cling
RUN source activate cling
RUN mamba install xeus-cling -c conda-forge

RUN conda update conda

# javascript / nodejs cuz why not

USER root
RUN apt-get update --yes
RUN apt install -y npm
RUN npm install -g deno
RUN apt-get install -y nodejs npm jupyter postgresql-client
RUN deno jupyter --unstable --install
#RUN ijsinstall --install=global

# JJava Kernel
RUN curl -Ls https://sh.jbang.dev | bash -s - app setup
RUN /home/jovyan/.jbang/bin/jbang trust add https://github.com/jupyter-java/
RUN /home/jovyan/.jbang/bin/jbang install-kernel@jupyter-java jjava


USER ${NB_UID}

# javascript?
#RUN npm install -g ijavascript 
#RUN ijsinstall

# return to home directory
WORKDIR /home/jovyan
