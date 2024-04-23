#
#  Ubuntu OS
#

# Base image

FROM ubuntu:22.04

# Install software

RUN apt update
RUN apt upgrade -y
RUN apt install -y \
    openssh-server

# Expose SSH port

EXPOSE 22

# Create SSH credentials

WORKDIR /root
RUN mkdir .ssh
COPY authorized_keys .ssh/

# Start OS

ENTRYPOINT service ssh start && bash

# End of configuration
