#!/bin/bash

# Ensures runs in the current dir
    cd $(dirname "$0")

# initiatlises the directory
    terraform init

# Gets the branch to make as realistic as possible
    BRANCH=$(git rev-parse --short HEAD)

# Creates a dummy image map
    IMAGES="{master=000000,node=000000}"

# Performs a dir level validation 
    terraform validate -var "token=${DO_TOKEN}" -var "image_ids=${IMAGES}" -var "branch=${BRANCH}" 