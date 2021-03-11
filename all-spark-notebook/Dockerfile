# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/pyspark-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib
RUN fix-permissions $R_LIBS_USER

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=3.6.3' \
    'r-ggplot2=3.3*' \
    'r-irkernel=1.1*' \
    'r-rcurl=1.98*' \
    'r-sparklyr=1.2*' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Spylon-kernel
RUN conda install --quiet --yes 'spylon-kernel=0.4*' && \
    conda clean --all -f -y && \
    python -m spylon_kernel install --sys-prefix && \
    rm -rf "/home/${NB_USER}/.local" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

### Pecanstreet modifications
# update conda
RUN conda update -n base conda
RUN /opt/conda/bin/pip3 install pandas matplotlib psycopg2-binary bash_kernel

# install bash kernel
RUN python3 -m bash_kernel.install

# install ijava kernel
RUN mkdir /tmp/ijava
WORKDIR /tmp/ijava
COPY ijava-1.3.0.zip /tmp/ijava/ijava-1.3.0.zip
RUN unzip /tmp/ijava/ijava-1.3.0.zip 
RUN python3 install.py --sys-prefix 
RUN rm -rf /tmp/ijava

# c kernel
# RUN pip3 install jupyter-c-kernel && install_c_kernel

# c++ xeus kernel
RUN conda install --yes -c conda-forge xeus-cling

RUN conda update conda

# javascript / nodejs cuz why not
RUN npm install -g ijavascript && ijsinstall

# return to home directory
WORKDIR /home/jovyan
