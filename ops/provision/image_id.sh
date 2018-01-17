#!/bin/bash

# Gets the name
    IMAGE_ID=$(jq -r .builds[].artifact_id $1_manifest.json)
    echo ${IMAGE_ID#:} >> $1_image_id.txt
