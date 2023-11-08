# FROM continuumio/miniconda3:latest
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ARG username
ARG uid
ARG gid

# Set environment variables.
## Set non-interactive to prevent asking for user inputs blocking image creation.
ENV DEBIAN_FRONTEND=noninteractive
## Set timezone as it is required by some packages.
ENV TZ=Europe/Berlin
## CUDA architectures, required by tiny-cuda-nn.
# ARG MY_GPU_ARCH=86
# ENV TCNN_CUDA_ARCHITECTURES=${MY_GPU_ARCH}
## CUDA Home, required to find CUDA in some packages.
ENV CUDA_HOME="/usr/local/cuda"

# Install basic apt packages.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    nano \
    vim \
    wget \
    curl

SHELL ["/bin/bash", "-c"]
WORKDIR /workspace

# Create non root user and setup environment.
## The user has exactly the same uid:gid as builder
## which allows read/write to mounted volumn
RUN groupadd -g ${gid} -o ${username}
RUN useradd -m -d /home/${username} -u ${uid} -g ${gid} -o ${username}

# Switch to new uer and workdir.
USER ${username}
WORKDIR /home/${username}

# Install conda
ARG CONDA_INSTALL_DIR=/home/${username}/miniconda3
RUN mkdir -p ${CONDA_INSTALL_DIR}
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${CONDA_INSTALL_DIR}/miniconda.sh
RUN bash ${CONDA_INSTALL_DIR}/miniconda.sh -b -u -p ${CONDA_INSTALL_DIR}
RUN rm -rf ${CONDA_INSTALL_DIR}/miniconda.sh
RUN ${CONDA_INSTALL_DIR}/bin/conda init bash

# Set path to conda
ENV ORIG_PATH=${PATH}
ENV PATH=${CONDA_INSTALL_DIR}/bin:${PATH}

# Update conda and install packages
RUN conda update -y conda && \
    conda install python=3.9 pip

RUN conda install -y cudatoolkit=11.6 -c conda-forge
RUN pip install torch==1.13.1+cu116 torchvision==0.14.1+cu116 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu116
RUN pip install tqdm scikit-image opencv-python configargparse lpips imageio-ffmpeg lpips tensorboard numpy==1.22.4 sk-video trimesh wandb omegaconf pysdf pymcubes matplotlib pytorch-lightning==1.6.5 gdown

ENV PATH=$ORIG_PATH

# additional system packages
USER root
RUN apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    ffmpeg

USER ${username}

ENTRYPOINT unset ORIG_PATH && /bin/bash
