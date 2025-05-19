#!/usr/bin/env bash
set -ex

# Check if the operating system is Debian-based or has the "noble" codename in OS release
if grep -q "ID=debian" /etc/os-release || grep -q "VERSION_CODENAME=noble" /etc/os-release; then
    # Remove Ansible package
    apt-get purge -y ansible
else
    # Remove Ansible package
    apt-get purge -y ansible

    # Remove Ansible PPA
    apt-add-repository --remove -y ppa:ansible/ansible
fi

# Cleanup leftover dependencies
apt-get autoremove -y
apt-get autoclean

# Clear the cache to free up space
rm -rf /var/lib/apt/lists/*