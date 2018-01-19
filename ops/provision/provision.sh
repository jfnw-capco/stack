#!/bin/bash

# Validate the Packer file
    packer validate -var-file=node_config.json -var "do_token=${DO_TOKEN}" node.json

# Runs the build
    packer build -var -var-file=node_config.json -var "do_token=${DO_TOKEN}" node.json