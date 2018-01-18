#!/bin/bash

# Calculates the variables
    VERSION=$1
    FILE="doctl-${VERSION}-linux-amd64.tar.gz"
    URL="https://github.com/digitalocean/doctl/releases/download/v${VERSION}/${FILE}"


# Downloads and unzips
    cd /tmp
    wget -q $URL
    tar xf ${FILE}
    mv doctl /usr/local/bin