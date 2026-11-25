#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PKG_NAME="hackbar"
PKG_VER="1.0.0"
ARCH="all"
STAGE_DIR="${REPO_ROOT}/build-deb-stage"
OUT_DEB="${REPO_ROOT}/hackbar.deb"

rm -rf "${STAGE_DIR}"
mkdir -p \
  "${STAGE_DIR}/DEBIAN" \
  "${STAGE_DIR}/usr/share/hackbar" \
  "${STAGE_DIR}/usr/local/bin" \
  "${STAGE_DIR}/usr/share/applications"

cp "${REPO_ROOT}/hackbar.py" "${STAGE_DIR}/usr/share/hackbar/hackbar.py"
chmod 0644 "${STAGE_DIR}/usr/share/hackbar/hackbar.py"

cat <<'EOF' > "${STAGE_DIR}/DEBIAN/control"
Package: hackbar
Version: 1.0.0
Section: utils
Priority: optional
Architecture: all
Maintainer: HackBar Maintainer <maintainers@example.invalid>
Depends: python3 (>= 3.10), xfce4-terminal, iproute2, iputils-ping, dnsutils, traceroute, arp-scan, procps, nmap, masscan, exploitdb, theharvester, whois, curl, whatweb, nikto, gobuster, sqlmap, ffuf, aircrack-ng, hydra, john, hashcat, hashid, netcat-openbsd, binwalk, exiftool, tshark
Recommends: metasploit-framework, zaproxy
Description: Interactive terminal command search and learning utility for security tools
 HackBar translates plain-English tasks into standard Linux networking and
 security CLI commands with syntax explanations and mastery tracking.
EOF
chmod 0644 "${STAGE_DIR}/DEBIAN/control"

cat <<'EOF' > "${STAGE_DIR}/usr/local/bin/hackbar"
#!/usr/bin/env bash
set -euo pipefail
exec python3 /usr/share/hackbar/hackbar.py --user "${USER:-me}" "$@"
EOF
chmod 0755 "${STAGE_DIR}/usr/local/bin/hackbar"

cat <<'EOF' > "${STAGE_DIR}/usr/share/applications/hackbar.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=HackBar
Comment=Terminal security command search and learning utility
Exec=hackbar
Icon=utilities-terminal
Terminal=true
Categories=Utility;Security;
StartupNotify=false
EOF
chmod 0644 "${STAGE_DIR}/usr/share/applications/hackbar.desktop"

dpkg-deb --build --root-owner-group "${STAGE_DIR}" "${OUT_DEB}"
rm -rf "${STAGE_DIR}"
