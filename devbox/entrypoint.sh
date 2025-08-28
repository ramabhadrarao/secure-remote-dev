#!/bin/bash

# Update password if environment variable is set
if [ ! -z "$DEVBOX_RDP_PASSWORD" ] && [ ! -z "$DEVBOX_RDP_USER" ]; then
    echo "Setting password for user $DEVBOX_RDP_USER"
    echo "$DEVBOX_RDP_USER:$DEVBOX_RDP_PASSWORD" | chpasswd
fi

# Start dbus
service dbus start

# Start XRDP
service xrdp start

# Configure user environment on first run
if [ ! -f /home/$DEVBOX_RDP_USER/.configured ]; then
    echo "Running first-time configuration for $DEVBOX_RDP_USER..."
    
    # Run as the user
    su - $DEVBOX_RDP_USER -c "
        # Mark as configured
        touch ~/.configured
        
        # Run XFCE configuration
        if [ -f ~/xfce-config.sh ]; then
            bash ~/xfce-config.sh
        fi
        
        # Setup Chrome
        if [ -f ~/setup-chrome.sh ]; then
            bash ~/setup-chrome.sh
        fi
        
        # Setup VS Code with Gitea
        if [ -f ~/setup-vscode.sh ]; then
            bash ~/setup-vscode.sh
        fi
    "
fi

# Execute the main command
exec "$@"