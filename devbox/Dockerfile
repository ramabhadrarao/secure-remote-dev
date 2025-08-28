FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Basic packages, XFCE, XRDP, dev tools
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils \
    xrdp sudo curl wget git ca-certificates gnupg lsb-release \
    build-essential zip unzip \ 
    && rm -rf /var/lib/apt/lists/*

# Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \ 
    && apt-get update && apt-get install -y nodejs \ 
    && rm -rf /var/lib/apt/lists/*

# Python 3.11 and pip
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv \ 
    && rm -rf /var/lib/apt/lists/*

# VS Code OSS (code-oss) via Microsoft repo alternative (codium would also work)
RUN apt-get update && apt-get install -y wget gpg \ 
    && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/ms.gpg \ 
    && echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/ms.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list \ 
    && apt-get update && apt-get install -y code \ 
    && rm -rf /var/lib/apt/lists/*

# Configure XRDP
RUN sed -i 's/port=3389/port=3389/g' /etc/xrdp/xrdp.ini && \ 
    adduser xrdp ssl-cert

# Create RDP user
ARG USERNAME=dev
ARG USERPASS=DevBoxPass123!
RUN useradd -m -s /bin/bash ${USERNAME} && echo "${USERNAME}:${USERPASS}" | chpasswd && adduser ${USERNAME} sudo

# XFCE session for XRDP
RUN echo "xfce4-session" > /home/${USERNAME}/.xsession && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.xsession

# Autostart XRDP
EXPOSE 3389
CMD service xrdp start && tail -f /var/log/xrdp-sesman.log
