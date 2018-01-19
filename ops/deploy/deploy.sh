#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")

# Gets the branch ID
    BRANCH=$(git rev-parse --short HEAD)

# initiatlises the directory
    terraform init

# Validates the plan    
    terraform validate -var "token=${DO_TOKEN}" -var "image_id=$1" -var "branch=${BRANCH}" 

# Outputs the the plan
    terraform plan -var "token=${DO_TOKEN}" -var "image_id=$1" -var "branch=${BRANCH}" -out=terraform.plan -lock=true

# Performs the changes to the infrastructure
    terraform apply -var "token=${DO_TOKEN}" -var "image_id=$1" -var "branch=${BRANCH}" -auto-approve -lock=true
