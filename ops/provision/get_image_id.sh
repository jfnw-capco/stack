#!/bin/bash

# Makes the directory if needed
    mkdir mkdir -p ${1}

# Ensures runs in the current directory 
    cd $(dirname "$0")

# Writes the current image
    IMAGE_ID=$(jq -r .builds[].artifact_id "${2}/${2}_manifest.json")
    echo ${IMAGE_ID#:} >> "${1}/${2}.id"