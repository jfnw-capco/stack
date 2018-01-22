#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")

# Writes the current image
    IMAGE_ID=$(jq -r .builds[].artifact_id "${1}/${1}_manifest.json")
    echo ${IMAGE_ID#:} >> "${1}.txt"