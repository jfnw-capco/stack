#!/bin/bash

# Gets the name
    IMAGE_NAME=$(jq -r .builds[].artifact_id image-manifest.json)
    IMAGE_NAME=${IMAGE_NAME#:}
    
# Makes available
    export IMAGE_NAME
