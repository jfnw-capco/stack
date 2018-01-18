#!/bin/bash

# Retrieves the Image ID
    if [ ! -d state ]; then
        mkdir state
    fi

    cp ../provision/state/current_image_id.txt state/image_id.txt
    IMAGE_ID=$(cat state/image_id.txt) 
    
# initiatlises the directory
    terraform init

# Validates the plan    
    terraform validate -var "token=${DO_TOKEN}" -var "image_id=${IMAGE_ID}" 

# Outputs the the plan
    terraform plan -var "token=${DO_TOKEN}" -var "image_id=${IMAGE_ID}" -out=terraform.plan -lock=true

# Performs the changes to the infrastructure
    terraform apply -var "token=${DO_TOKEN}" -var "image_id=${IMAGE_ID}" -auto-approve -lock=true
