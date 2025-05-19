#!/usr/bin/env bash
set -ex

# Check the architecture
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')

if [ "${ARCH}" == "arm64" ] ; then
    echo "No Terraform installed for arm64, nothing to uninstall."
    exit 0
fi

# Remove Terraform package
apt-get purge -y terraform

# Remove HashiCorp APT repository
rm -f /etc/apt/sources.list.d/hashicorp.list

# Remove the HashiCorp GPG key (if it exists in the keyring)
apt-key list | grep -q "HashiCorp" && apt-key del $(apt-key list | grep -B 1 'HashiCorp' | head -n 1 | awk '{print $2}')

# Cleanup
apt-get autoremove -y
apt-get autoclean

# Clear the cache and remove temporary files to free up space
rm -rf /var/lib/apt/lists/*
rm -rf /var/tmp/*
rm -rf /tmp/*