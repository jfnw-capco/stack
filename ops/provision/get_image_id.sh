#!/bin/bash

# Makes the directory if needed
    mkdir -p ${1}

# Ensures runs in the current directory 
    cd $(dirname "$0")

# Writes the current image
    IMAGE_ID=$(jq -r .builds[].artifact_id "${2}/${2}_manifest.json")

# Changes to the state directory
    cd ${1}
    pwd
    ls ${1}
    echo ${IMAGE_ID#:} >> "${2}.id"