#!/bin/bash

# Sets the Swarm ports 
    ufw allow 22/tcp
    ufw allow 2376/tcp
    ufw allow 2377/tcp
    ufw allow 7946/tcp
    ufw allow 7946/udp
    ufw allow 4789/udp

# Refreshs the firewall
    ufw --force reload
    ufw --force enable

# Restart Docker to be sure
    systemctl restart docker

# Create as the swarm master here 
    # docker swarm init --advertise-addr <MANAGER-IP>

# This will return the token to use for workers
    # docker swarm join-token worker

# Create a docker registry in the swarm
    # docker service create --name registry --publish published=5000,target=5000 registry:2

# Docker compose can be stood up 
    # TODO here

# In the directory where compose is
    # docker-compose push

# docker stack deploy --compose-file docker-compose.yml stackdemo
    # Deploys across the swarm 