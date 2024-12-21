#!/bin/bash

# Define the list of RPM URLs
RPM_URLS=(
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-atomic-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-chrono-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-date-time-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-iostreams-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-program-options-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-random-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-regex-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-system-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/b/boost-thread-1.66.0-13.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/d/daxctl-devel-71.1-7.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/f/fio-3.19-4.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/l/libpmem-1.6.1-1.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/l/libpmemblk-1.6.1-1.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/l/librados2-12.2.7-9.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/l/librbd1-12.2.7-9.el8.x86_64.rpm"
    "https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/n/ndctl-devel-71.1-7.el8.x86_64.rpm"
)

# Create a temporary directory for downloads
TEMP_DIR=$(mktemp -d)

# Function to clean up temporary directory on exit
cleanup() {
    echo "Cleaning up..."
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Change to the temporary directory
cd "$TEMP_DIR"

# Download all RPMs
for URL in "${RPM_URLS[@]}"; do
    echo "Downloading $URL..."
    curl -O "$URL"
    if [ $? -ne 0 ]; then
        echo "Failed to download $URL"
        exit 1
    fi
done

# Install the downloaded RPMs using dnf without GPG check
echo "Installing RPMs..."
sudo dnf install -y --nogpgcheck ./*.rpm

if [ $? -eq 0 ]; then
    echo "All RPMs installed successfully."
else
    echo "There was an error installing the RPMs."
    exit 1
fi
