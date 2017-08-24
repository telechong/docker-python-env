FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        ssh \
        dialog \
        apt-utils \
        build-essential \
        cmake \
	    git \
        curl \
        ca-certificates

# Netowrk supports
RUN apt-get install -y --no-install-recommends \
        iputils-ping \
        net-tools

# Python supports
RUN apt-get install -y \
        python3-pip \
        python3-venv \
        pep8 \
        pep257 \
        pylint


# Install latest vim(8.0)
RUN apt-get install -y \
        python-software-properties \
        software-properties-common
RUN add-apt-repository -y ppa:pi-rho/dev
RUN apt-get update && \
    apt-get install -y \
        vim-gtk

# To be able to build YCompleteMe
RUN apt-get install -y \
        python-dev \
        libxml2-dev \
        libxslt-dev

# Powerline supports
RUN apt-get install -y \
        fontconfig \
        powerline

RUN rm -rf /var/lib/apt/lists/*


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
ARG G_ID=$USER_ID
ARG G_NAME=$USER_NAME
RUN groupadd -g $G_ID $G_NAME
RUN echo "$USER_NAME:x:$USER_ID:$G_ID:,,,:/home/$USER_NAME:/bin/bash" >> /etc/passwd
RUN mkhomedir_helper $USER_NAME
RUN adduser $USER_NAME sudo


# Set root's password
ARG ROOT_PASSWD
RUN echo "root:$ROOT_PASSWD" | chpasswd


# Setup vim environment
ARG USER_VIMRC=/home/$USER_NAME/.vimrc
COPY vimrc $USER_VIMRC
COPY .vim /home/$USER_NAME/.vim
#RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/$USER_NAME/.vim/bundle/Vundle.vim
#RUN vim +PluginInstall +qall &>/dev/null
RUN /home/$USER_NAME/.vim/bundle/YouCompleteMe/install.py
RUN chown -R $USER_NAME:$G_NAME /home/$USER_NAME


# Setup powerline
RUN echo "powerline-daemon -q" >> /etc/bash.bashrc
RUN echo "POWERLINE_BASH_CONTINUATION=1" >> /etc/bash.bashrc
RUN echo "POWERLINE_BASH_SELECT=1" >> /etc/bash.bashrc
RUN echo ". ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh" >> /etc/bash.bashrc

# Git settings
ARG USER_MAIL
ARG USER_FULL_NAME
RUN echo "git config --global user.email \"$USER_MAIL\"" >> /etc/bash.bashrc
RUN echo "git config --global user.name \"$USER_FULL_NAME\"" >> /etc/bash.bashrc


ENV PATH /opt/conda/bin:$PATH


ENTRYPOINT /bin/bash
