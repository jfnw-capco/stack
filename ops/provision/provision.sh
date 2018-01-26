#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")   

    # Ensures manifest will only hold one image id 
    if [ -f "${1}_manifest.json" ]; then
        rm "${1}_manifest.json" -f
    fi 

    # Gets the branch ID
        BRANCH=$(git rev-parse --short HEAD)

    # Validate the Packer file
        packer validate -var-file="variables.json" -var "do_token=${DO_TOKEN}" -var "branch=${BRANCH}" -var "image=${1}" "${1}/${1}_image.json"

    # Runs the build
        packer build -var-file="variables.json" -var "do_token=${DO_TOKEN}" -var "branch=${BRANCH}" -var "image=${1}" -on-error="cleanup" "${1}/${1}_image.json"
