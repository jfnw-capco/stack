#!/bin/bash

# Ensures runs in the current dir
    cd $(dirname "$0")

# Uses the CircleCI for validation
    circleci config validate -c config.yml