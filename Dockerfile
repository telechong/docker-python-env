FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        build-essential \
        cmake \
	    git \
        curl \
        ca-certificates \
	    vim && \
    rm -rf /var/lib/apt/lists/*


#RUN curl -o ~/miniconda.sh -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
#    chmod +x ~/miniconda.sh && \
#    ~/miniconda.sh -b -p /opt/conda && \
#    rm ~/miniconda.sh && \
#    /opt/conda/bin/conda install conda-build && \
#    /opt/conda/bin/conda clean -ya


# Create user to map to the host user
# The user need to specify USER_ID and USER_NAME when build the image
# e.g. docker build --build-arg USER_ID=1000 --build-arg USER_NAME=appuser .
ARG USER_ID
ARG USER_NAME
RUN echo "$USER_NAME:x:$USER_ID:$USER_ID:,,,:/home/$USER_NAME:/bin/bash" >> /etc/passwd
RUN mkhomedir_helper $USER_NAME
RUN adduser $USER_NAME sudo

# Set root's password
ARG ROOT_PASSWD
RUN echo "root:$ROOT_PASSWD" | chpasswd

ENV PATH /opt/conda/bin:$PATH


ENTRYPOINT /bin/bash
