#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

apt-get update
apt-get purge -y mintwelcome 'mint-backgrounds-*' || true
apt-get autoremove -y

apt-get install -y --no-install-recommends \
  xfce4-appmenu-plugin \
  appmenu-gtk3-module \
  appmenu-gtk2-module \
  plank \
  picom \
  rofi \
  git \
  curl \
  ca-certificates \
  gtk2-engines-murrine \
  sassc \
  libglib2.0-dev-bin \
  librsvg2-2 \
  gnome-themes-extra

rm -rf /tmp/whitesur-build
mkdir -p /tmp/whitesur-build
cd /tmp/whitesur-build

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
(
  cd WhiteSur-gtk-theme
  ./install.sh -t all -N mojave -o solid -c Dark -c Light -m -s standard -l
)

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
(
  cd WhiteSur-icon-theme
  ./install.sh -t all
)

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git
(
  cd WhiteSur-cursors
  ./install.sh
)

mkdir -p /usr/share/backgrounds/macos
curl -fsSL "https://raw.githubusercontent.com/vinceliuice/WhiteSur-wallpapers/main/4k/Monterey-Dark.jpg" \
  -o /usr/share/backgrounds/macos/wallpaper.jpg || true

mkdir -p \
  /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml \
  /etc/skel/.config/plank/dock1/launchers \
  /etc/skel/.config/rofi \
  /etc/skel/.config/picom \
  /etc/skel/.config/autostart

cat <<'EOF' > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="WhiteSur-Dark-solid"/>
    <property name="IconThemeName" type="string" value="WhiteSur-dark"/>
    <property name="EnableInputFeedbackSounds" type="bool" value="false"/>
    <property name="EnableEventSounds" type="bool" value="false"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="int" value="96"/>
    <property name="Antialias" type="int" value="1"/>
    <property name="Hinting" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="CursorThemeName" type="string" value="WhiteSur-cursors"/>
    <property name="CursorThemeSize" type="int" value="24"/>
    <property name="FontName" type="string" value="Inter 10"/>
    <property name="Modules" type="string" value="appmenu-gtk-module"/>
  </property>
</channel>
EOF

cat <<'EOF' > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="WhiteSur-Dark-solid"/>
    <property name="title_font" type="string" value="Inter Bold 10"/>
    <property name="title_alignment" type="string" value="center"/>
    <property name="button_layout" type="string" value="CHM|"/>
    <property name="full_width_title" type="bool" value="false"/>
    <property name="focus_delay" type="int" value="250"/>
    <property name="raise_delay" type="int" value="250"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="false"/>
    <property name="wrap_windows" type="bool" value="false"/>
    <property name="use_compositing" type="bool" value="false"/>
  </property>
</channel>
EOF

cat <<'EOF' > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=6;x=0;y=0"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="28"/>
      <property name="nrows" type="uint" value="1"/>
      <property name="background-style" type="uint" value="1"/>
      <property name="background-rgba" type="array">
        <value type="double" value="0.11"/>
        <value type="double" value="0.11"/>
        <value type="double" value="0.12"/>
        <value type="double" value="0.72"/>
      </property>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="applicationsmenu">
      <property name="button-title" type="string" value=""/>
      <property name="show-button-title" type="bool" value="true"/>
      <property name="show-generic-names" type="bool" value="false"/>
      <property name="show-menu-icons" type="bool" value="true"/>
    </property>
    <property name="plugin-2" type="string" value="appmenu"/>
    <property name="plugin-3" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-4" type="string" value="systray">
      <property name="square-icons" type="bool" value="true"/>
    </property>
    <property name="plugin-5" type="string" value="clock">
      <property name="digital-format" type="string" value="%a %b %d  %H:%M"/>
    </property>
  </property>
</channel>
EOF

cat <<'EOF' > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-keyboard-shortcuts" version="1.0">
  <property name="commands" type="empty">
    <property name="custom" type="empty">
      <property name="&lt;Super&gt;space" type="string" value="rofi -show drun -modi drun,run -show-icons"/>
    </property>
  </property>
</channel>
EOF

cat <<'EOF' > /etc/skel/.config/plank/dock1/settings.ini
[PlankDockPreferences]
Alignment=3
AutoHide=true
CurrentTheme=Gtk+
HideDelay=0
IconSize=48
Position=3
ShowDockItem=false
UnhideDelay=0
ZoomEnabled=true
ZoomPercent=135
EOF

cat <<'EOF' > /etc/skel/.config/plank/dock1/launchers/xfce4-terminal.dockitem
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/xfce4-terminal.desktop
EOF

cat <<'EOF' > /etc/skel/.config/plank/dock1/launchers/hackbar.dockitem
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/hackbar.desktop
EOF

cat <<'EOF' > /etc/skel/.config/rofi/config.rasi
configuration {
    modi: "drun,run";
    show-icons: true;
    terminal: "xfce4-terminal";
    drun-display-format: "{name}";
    font: "Inter 12";
}
EOF

cat <<'EOF' > /etc/skel/.config/picom/picom.conf
backend = "glx";
vsync = true;
corner-radius = 12;
rounded-corners-exclude = [
  "class_g = 'Plank'",
  "class_g = 'Xfce4-panel'",
  "class_g = 'Rofi'"
];
shadow = true;
shadow-radius = 18;
shadow-opacity = 0.45;
inactive-opacity = 0.96;
active-opacity = 1.0;
EOF

cat <<'EOF' > /etc/skel/.config/autostart/plank.desktop
[Desktop Entry]
Type=Application
Name=Plank
Exec=plank
OnlyShowIn=XFCE;
X-GNOME-Autostart-enabled=true
EOF

cat <<'EOF' > /etc/skel/.config/autostart/picom.desktop
[Desktop Entry]
Type=Application
Name=Picom
Exec=picom -b
OnlyShowIn=XFCE;
X-GNOME-Autostart-enabled=true
EOF

if [ -f /tmp/hackbar.deb ]; then
  apt-get install -y /tmp/hackbar.deb
  rm -f /tmp/hackbar.deb
fi

rm -rf /tmp/whitesur-build
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
