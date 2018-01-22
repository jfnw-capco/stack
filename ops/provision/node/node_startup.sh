#!/bin/bash

# Sets the Swarm ports 
    ufw allow 22/tcp
    ufw allow 2376/tcp
    ufw allow 7946/tcp 
    ufw allow 7946/udp 
    ufw allow 4789/udp 

# Refreshs the firewall
    ufw reload
    ufw enable

# Restart Docker to be sure
    systemctl restart docker

# Temp
    cd /app
    docker-compose -p "api" up --scale app=3 -d
