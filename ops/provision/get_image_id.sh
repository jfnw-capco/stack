#!/bin/bash

# Writes the current image
    IMAGE_ID=$(jq -r .builds[].artifact_id ${#1})
    echo ${IMAGE_ID#:}