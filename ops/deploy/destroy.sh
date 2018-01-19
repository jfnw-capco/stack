#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")

# initiatlises the directory
    terraform init

# Validates the plan    
    terraform validate -var "token=${DO_TOKEN}" -var "image_id=$1" 

# Outputs the the plan
    terraform plan -var "token=${DO_TOKEN}" -var "image_id=$1" -destroy -out=terraform.plan -lock=true

# Performs the destroy 
    terraform destroy -var "token=${DO_TOKEN}" -var "image_id=$1" -refresh=true -force -lock=true 
