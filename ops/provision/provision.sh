#!/bin/bash

# Removes previous manifest 
    if [ -f node_manifest.json ]; then
        rm node_manifest.json
    fi
    
# Gets the current Git short branch
    PUID=$(git rev-parse --short HEAD)

# Validate the Packer file
    packer validate -var-file=node_config.json -var "do_token=${DO_TOKEN}" node.json

# Runs the build
    packer build -var -var-file=node_config.json -var "do_token=${DO_TOKEN}" node.json

# Makes a state directory 
    if [ ! -d state ]; then
        mkdir state
    fi
    cd state

# Removes the last_image_id
    if [ -f previous_image_id.txt ]; then
        rm previous_image_id.txt
    fi

# Renames the previous image if exists
    if [ -f current_image_id.txt ]; then
        mv current_image_id.txt previous_image_id.txt
    fi
    
# Writes the current image
    IMAGE_ID=$(jq -r .builds[].artifact_id ../node_manifest.json)
    echo ${IMAGE_ID#:} >> current_image_id.txt

# Remove the previous image if required
    if [ -f previous_image_id.txt ]; then
        doctl compute image delete $(cat previous_image_id.txt) -f
    fi