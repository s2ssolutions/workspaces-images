#!/usr/bin/env bash
set -ex

echo "Uninstalling Firefox and undoing configurations..."

# Identify the user whose home directory was modified (defaulting to UID 1000)
USER_HOME=$(getent passwd 1000 | cut -d: -f6)
# apt-get update

# Remove the Firefox package and any related plugins and dependencies
apt-get purge -y firefox firefox-esr p11-kit-modules
# apt-get autoremove -y
# apt-get autoclean -y

# Remove Mozilla PPA repository and pin preferences
add-apt-repository -r -y ppa:mozillateam/ppa || true
rm -f /etc/apt/preferences.d/mozilla-firefox /etc/apt/preferences.d/mozilla.list
rm -f /etc/apt/sources.list.d/mozilla.list

# Remove icons from the desktop
if [ -f "${USER_HOME}/Desktop/firefox.desktop" ]; then
    rm -f "${USER_HOME}/Desktop/firefox.desktop"
fi

# Remove language packs
EXTENSION_DIR="/usr/lib/firefox-addons/distribution/extensions/"
if [ -d "${EXTENSION_DIR}" ]; then
    rm -rf "${EXTENSION_DIR}"
fi

# Remove Firefox certificates and update the system certificate store
if [ -L /usr/lib/firefox/libnssckbi.so ]; then
    rm -f /usr/lib/firefox/libnssckbi.so || true
fi
if [ -L /usr/lib/firefox-esr/libnssckbi.so ]; then
    rm -f /usr/lib/firefox-esr/libnssckbi.so || true
fi

# Remove default profile directory and profiles.ini
FIREFOX_PROFILE_DIR="${USER_HOME}/.mozilla/firefox"
if [ -d "${FIREFOX_PROFILE_DIR}" ]; then
    rm -rf "${FIREFOX_PROFILE_DIR}"
fi
if [ -f "${USER_HOME}/.mozilla/firefox/profiles.ini" ]; then
    rm -f "${USER_HOME}/.mozilla/firefox/profiles.ini"
fi

# Cleanup any remaining Firefox-related files in /usr/share and system-level directories
find /usr/share -name "firefox*" -exec rm -rf {} +
find /usr/lib -name "firefox*" -exec rm -rf {} +
find /usr/lib64 -name "firefox*" -exec rm -rf {} + || true

# Remove cached APT files
rm -rf /var/lib/apt/lists/*

# Remove temporary files leftover during the installation
rm -rf /tmp/*
rm -rf /var/tmp/*

# Cleanup desktop icon leftovers
if [ -f "${USER_HOME}/Desktop/firefox-esr.desktop" ]; then
    rm -f "${USER_HOME}/Desktop/firefox-esr.desktop"
fi

# CertDB cleanup created during profile creation (if any)
if [ -d "${USER_HOME}/.mozilla" ]; then
    rm -rf "${USER_HOME}/.mozilla"
fi

echo "Firefox has been completely uninstalled."