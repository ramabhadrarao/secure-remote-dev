#!/bin/bash

# Create XFCE config directories
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml

# Disable compositing for better performance
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="use_compositing" type="bool" value="false"/>
    <property name="box_move" type="bool" value="false"/>
    <property name="box_resize" type="bool" value="false"/>
    <property name="sync_to_vblank" type="bool" value="false"/>
    <property name="cycle_draw_frame" type="bool" value="false"/>
    <property name="frame_opacity" type="int" value="100"/>
    <property name="show_frame_shadow" type="bool" value="false"/>
    <property name="show_popup_shadow" type="bool" value="false"/>
  </property>
</channel>
EOF

# Optimize XFCE desktop settings
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="desktop-icons" type="empty">
    <property name="file-icons" type="empty">
      <property name="show-filesystem" type="bool" value="false"/>
      <property name="show-removable" type="bool" value="false"/>
    </property>
  </property>
</channel>
EOF

# Optimize panel settings
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="background-alpha" type="uint" value="100"/>
      <property name="disable-struts" type="bool" value="false"/>
    </property>
  </property>
</channel>
EOF

# Disable screen saver and power management
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-power-manager" version="1.0">
  <property name="xfce4-power-manager" type="empty">
    <property name="dpms-enabled" type="bool" value="false"/>
    <property name="blank-on-ac" type="int" value="0"/>
    <property name="dpms-on-ac-sleep" type="uint" value="0"/>
    <property name="dpms-on-ac-off" type="uint" value="0"/>
  </property>
</channel>
EOF

# Create autostart directory
mkdir -p ~/.config/autostart

# Add Chrome to autostart with restricted mode
cat > ~/.config/autostart/chrome.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Google Chrome (Restricted)
Exec=/usr/bin/google-chrome-stable --no-first-run --disable-features=TranslateUI
Icon=google-chrome
Terminal=false
StartupNotify=true
EOF

# Add VS Code to autostart
cat > ~/.config/autostart/vscode.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Visual Studio Code
Exec=/usr/bin/code --no-sandbox --disable-gpu-sandbox
Icon=code
Terminal=false
StartupNotify=true
EOF

echo "XFCE configuration completed"