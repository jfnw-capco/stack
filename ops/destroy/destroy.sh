#!/bin/bash

# Performs the destroy 
    terraform destroy -var "token=${DO_TOKEN}" -var "image_id=${#1}" -force -lock=true