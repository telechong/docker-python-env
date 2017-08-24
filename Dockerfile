FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
             build-essential \
    	     cmake \
	     git \
             curl \
             ca-certificates \
	     vim && \
    rm -rf /var/lib/apt/lists/*


RUN curl -o ~/miniconda.sh -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install conda-build && \
    /opt/conda/bin/conda clean -ya

ARG USER_ID
ARG USER_NAME

RUN echo "$USER_NAME:x:$USER_ID:$USER_ID:,,,:/home/$USER_NAME:/bin/bash" >> /etc/passwd
RUN mkhomedir_helper $USER_NAME


ENV PATH /opt/conda/bin:$PATH


ENTRYPOINT /bin/bash
