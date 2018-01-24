#!/bin/bash

# Validates the Docker files 
    dev/validate.sh

# Validates the Ops scripts
    ops/provision/validate.sh
    ops/deploy/validate.sh

# Validates the CircleCI 
    .circleci/validate.sh