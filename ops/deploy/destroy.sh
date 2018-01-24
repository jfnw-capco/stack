#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")/config

# Gets the branch ID
    BRANCH=$(git rev-parse --short HEAD)

# initiatlises the directory
    terraform init

# Validates the plan    
    terraform validate -var "token=${DO_TOKEN}" -var "image_ids=$1" -var "branch=${BRANCH}" 

# Outputs the the plan
    terraform plan -var "token=${DO_TOKEN}" -var "image_ids=$1" -var "branch=${BRANCH}" -destroy -out=terraform.plan -lock=true

# Performs the destroy 
    terraform apply "terraform.plan"

# Additional remove the DO images
    FILES=${2}/*.id

    for f in $FILES
    do
        doctl compute image delete $(cat $f) --access-token ${DO_TOKEN} --force
    done