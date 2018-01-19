#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")

# Gets the branch ID
    BRANCH=$(git rev-parse —short HEAD)

# Validate the Packer file
    packer validate -var-file=node_config.json -var "do_token=${DO_TOKEN}" -var "branch=${BRANCH}" node.json

# Runs the build
    packer build -var -var-file=node_config.json -var "do_token=${DO_TOKEN}" -var "branch=${BRANCH}" node.json