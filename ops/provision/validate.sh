#!/bin/bash

# Ensures runs in the current dir
    cd $(dirname "$0")

# Gets the branch ID
    BRANCH=$(git rev-parse --short HEAD)
    
# Loops around provision and calls the validate

    DIRS=$(ls -d */ | sed 's#/##')

    for IMAGE in $DIRS
    do
        packer validate -var-file="variables.json" -var "do_token=${DO_TOKEN}" -var "branch=${BRANCH}" -var "image=${IMAGE}" "${IMAGE}/${IMAGE}_image.json"
    done