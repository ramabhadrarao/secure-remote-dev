#!/bin/bash

# Create VS Code settings directory
mkdir -p ~/.config/Code/User

# Configure VS Code with Git and Gitea settings
cat > ~/.config/Code/User/settings.json << 'EOF'
{
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "git.autofetch": true,
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.fontSize": 14,
  "editor.fontSize": 14,
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "selection",
  "editor.wordWrap": "on",
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "workbench.startupEditor": "none",
  "telemetry.telemetryLevel": "off",
  "extensions.autoUpdate": false,
  "update.mode": "none",
  "window.menuBarVisibility": "visible"
}
EOF

# Configure Git globally for Gitea
git config --global user.name "${GITEA_USER:-dev}"
git config --global user.email "${GITEA_EMAIL:-dev@178.16.139.214}"
git config --global core.editor "code --wait"
git config --global credential.helper store

# Create a helper script for cloning from Gitea
cat > ~/git-clone-gitea.sh << 'EOF'
#!/bin/bash
# Helper script to clone from internal Gitea

GITEA_URL="http://git.178.16.139.214"
if [ -z "$1" ]; then
    echo "Usage: ~/git-clone-gitea.sh <repository-path>"
    echo "Example: ~/git-clone-gitea.sh admin/myproject"
    exit 1
fi

REPO_PATH="$1"
git clone "$GITEA_URL/$REPO_PATH.git"
EOF

chmod +x ~/git-clone-gitea.sh

# Create desktop shortcut for VS Code
cat > ~/Desktop/vscode.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Visual Studio Code
Comment=Code Editing. Redefined.
Exec=/usr/bin/code --no-sandbox --disable-gpu-sandbox %F
Icon=code
Terminal=false
Categories=Development;IDE;
StartupNotify=true
EOF

chmod +x ~/Desktop/vscode.desktop

# Create a welcome file with instructions
cat > ~/Desktop/README.txt << 'EOF'
Welcome to Your Secure Development Environment
==============================================

Quick Start:
-----------
1. Chrome Browser: Restricted to allowed websites only
   - ChatGPT, Google Search, GitHub, StackOverflow, MDN

2. VS Code: Pre-configured for development
   - Git is already configured
   - To clone a repository from Gitea:
     ~/git-clone-gitea.sh <user>/<repo>

3. Terminal: Available in menu or VS Code integrated terminal

4. Gitea Access: http://git.178.16.139.214
   Username: admin
   Password: Check with your administrator

Note: All work must be done within this environment.
No files can be transferred out of this system.
EOF

echo "VS Code setup completed with Gitea integration"