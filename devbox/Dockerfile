FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Basic packages, XFCE, XRDP, dev tools
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils \
    xrdp sudo curl wget git ca-certificates gnupg lsb-release \
    build-essential zip unzip software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add Chrome repository and install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Python 3.11 and pip
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# VS Code
RUN apt-get update && apt-get install -y wget gpg \
    && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/ms.gpg \
    && echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/ms.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update && apt-get install -y code \
    && rm -rf /var/lib/apt/lists/*

# Configure XRDP for better performance
RUN sed -i 's/port=3389/port=3389/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/max_bpp=32/max_bpp=24/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/xserverbpp=24/xserverbpp=24/g' /etc/xrdp/xrdp.ini && \
    echo "tcp_nodelay=true" >> /etc/xrdp/xrdp.ini && \
    echo "tcp_keepalive=true" >> /etc/xrdp/xrdp.ini && \
    echo "tcp_send_buffer_bytes=32768" >> /etc/xrdp/xrdp.ini && \
    adduser xrdp ssl-cert

# Create RDP user from environment variables
ARG USERNAME=dev
ARG USERPASS=DevBoxPass123!
RUN useradd -m -s /bin/bash ${USERNAME} && \
    echo "${USERNAME}:${USERPASS}" | chpasswd && \
    adduser ${USERNAME} sudo && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# XFCE session for XRDP with performance optimizations
RUN echo "xfce4-session" > /home/${USERNAME}/.xsession && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.xsession

# Copy configuration scripts
COPY --chown=${USERNAME}:${USERNAME} xfce-config.sh /home/${USERNAME}/xfce-config.sh
COPY --chown=${USERNAME}:${USERNAME} setup-chrome.sh /home/${USERNAME}/setup-chrome.sh
COPY --chown=${USERNAME}:${USERNAME} setup-vscode.sh /home/${USERNAME}/setup-vscode.sh
COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /home/${USERNAME}/xfce-config.sh \
    && chmod +x /home/${USERNAME}/setup-chrome.sh \
    && chmod +x /home/${USERNAME}/setup-vscode.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# Create Chrome launcher script
RUN cat > /usr/local/bin/start-chrome << 'EOF'
#!/bin/bash
export DISPLAY=${DISPLAY:-:10.0}
exec /usr/bin/google-chrome-stable \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --disable-software-rasterizer \
    --allow-file-access-from-files \
    "$@"
EOF
RUN chmod +x /usr/local/bin/start-chrome

# Create desktop shortcuts
RUN mkdir -p /home/${USERNAME}/Desktop && \
    cat > /home/${USERNAME}/Desktop/chrome.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Google Chrome
Exec=/usr/local/bin/start-chrome
Icon=google-chrome
Terminal=false
Categories=Network;WebBrowser;
StartupNotify=true
EOF
RUN chmod +x /home/${USERNAME}/Desktop/chrome.desktop && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/Desktop

# Create VS Code desktop shortcut
RUN cat > /home/${USERNAME}/Desktop/vscode.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Visual Studio Code
Exec=/usr/bin/code --no-sandbox --disable-gpu-sandbox
Icon=code
Terminal=false
Categories=Development;IDE;
StartupNotify=true
EOF
RUN chmod +x /home/${USERNAME}/Desktop/vscode.desktop && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/Desktop/vscode.desktop

# Set up Chrome policies directory
RUN mkdir -p /etc/opt/chrome/policies/managed \
    && mkdir -p /etc/opt/chrome/policies/recommended

# Don't copy policy file during build - we'll add it at runtime
# This avoids the read-only filesystem issue

EXPOSE 3389
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["tail", "-f", "/var/log/xrdp-sesman.log"]
