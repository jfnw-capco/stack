#!/bin/bash

# Retrieves the Image ID
    IMAGE_ID=$(cat ../provision/image_id.txt)

# Performs the destroy 
    terraform destroy -var "token=${DO_TOKEN}" -var "image_id=${IMAGE_ID}" -force -lock=true