#!/bin/bash

# Ensures runs in the current directory 
    cd $(dirname "$0")

# Writes the current image
    #IMAGE_ID=$(jq -r .builds[].artifact_id "node_manifest.json")
    IMAGE_ID=":31050288"
    IMAGE_ID=${IMAGE_ID#:}