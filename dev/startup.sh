#!/bin/bash

cd /app
docker-compose -p "api" up --scale app=3 -d
