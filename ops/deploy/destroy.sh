#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")

# Performs the destroy 
    terraform destroy -var "token=${DO_TOKEN}" -var "image_id=$1" -refresh=true -force -lock=true 