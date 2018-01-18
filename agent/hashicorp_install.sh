#!/bin/bash

# Calculates the variables
    PACKAGE=$1
    VERSION=$2
    FILE="${PACKAGE}_${VERSION}_linux_amd64.zip"
    URL="https://releases.hashicorp.com/${PACKAGE}/${VERSION}/${FILE}"


# Downloads and unzips
    cd /tmp
    wget -q $URL
    unzip $FILE
    sudo mv $PACKAGE /usr/bin
    /usr/bin/$PACKAGE --version