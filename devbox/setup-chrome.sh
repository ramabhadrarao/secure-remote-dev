#!/bin/bash

# Create Chrome user directories
mkdir -p ~/.config/google-chrome/Default
mkdir -p ~/.local/share/applications

# Set Chrome as default browser
xdg-settings set default-web-browser google-chrome.desktop 2>/dev/null || true

# Create Chrome preferences
cat > ~/.config/google-chrome/Default/Preferences << 'EOF'
{
  "browser": {
    "custom_chrome_frame": false,
    "has_seen_welcome_page": true
  },
  "profile": {
    "default_content_setting_values": {
      "notifications": 2,
      "geolocation": 2
    }
  },
  "signin": {
    "allowed": false
  },
  "safebrowsing": {
    "enabled": true
  }
}
EOF

# Create desktop shortcut for Chrome
cat > ~/Desktop/chrome-restricted.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Chrome (Restricted)
Comment=Access allowed websites only
Exec=/usr/bin/google-chrome-stable --no-first-run
Icon=google-chrome
Terminal=false
Categories=Network;WebBrowser;
StartupNotify=true
EOF

chmod +x ~/Desktop/chrome-restricted.desktop

echo "Chrome setup completed"