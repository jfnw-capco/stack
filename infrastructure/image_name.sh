#!/bin/bash

# Gets the name
    IMAGE_NAME=$(jq -r .builds[].artifact_id image-manifest.json)
    echo ${IMAGE_NAME#:} >> image_name.txt
