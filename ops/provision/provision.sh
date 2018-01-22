#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")

# Ensures manifest will only hold  image id
    if [ -f node_manifest.json ]; then
        rm node_manifest.json -f
    fi 

# Gets the branch ID
    BRANCH=$(git rev-parse --short HEAD)

# Validate the Packer file
    packer validate -var-file="variables.json" -var "do_token=${DO_TOKEN}" -var "branch=${BRANCH}" node.json

# Runs the build
    packer build -var-file="variables.json" -var "do_token=${DO_TOKEN}" -var "branch=${BRANCH}" -on-error="cleanup" node.json