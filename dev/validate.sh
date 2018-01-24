#!/bin/bash

# Ensures runs in the current dir
    cd $(dirname "$0")

# Validates the compose file
    docker-compose config -q

    echo "Stack configuration validated"