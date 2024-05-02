#
#  Ubuntu OS
#

# Base image

FROM ubuntu:22.04

# Install software

RUN apt update
RUN apt upgrade -y
RUN apt install -y \
    sudo \
    openssh-server \
    vim

# Default skeleton for users

COPY --chown=root:root .bash_aliases /etc/skel
COPY --chown=root:root .bashrc /etc/skel
COPY --chown=root:root .inputrc /etc/skel
COPY --chown=root:root .screenrc /etc/skel
COPY --chown=root:root .vimrc /etc/skel
COPY --chown=root:root .vim /etc/skel/.vim

# Setup bash shell

WORKDIR /root
COPY --chown=root:root .bash_aliases /root
COPY --chown=root:root .bashrc /root
COPY --chown=root:root .inputrc /root
COPY --chown=root:root .screenrc /root
COPY --chown=root:root .vimrc /root
COPY --chown=root:root .vim /root/.vim

# Expose SSH port

EXPOSE 22

# Create SSH credentials

RUN mkdir .ssh
COPY --chown=root:root authorized_keys .ssh/

# Start SSH client and container

ENTRYPOINT service ssh start && bash

# End of configuration
