#!/bin/bash

# Sets the Swarm ports 
    ufw allow 22/tcp
    ufw allow 2376/tcp 
    ufw allow 2377/tcp
    ufw allow 7946/tcp
    ufw allow 7946/udp
    ufw allow 4789/udp

# Docker registry port
    ufw allow 443/tcp
    ufw allow 80/tcp

# Refreshs the firewall
    ufw --force reload
    ufw --force enable

# Restart Docker to be sure
    systemctl restart docker

# Creates a local registry for the images to be pushed into
    docker run -d -p 80:5000 --restart=always --name registry registry:2

# Initiatizes the swarm 
    docker swarm init 

# Writes the values to the store 
    echo $(docker swarm join-token -q worker) >> token.swarm
    echo $(docker info --format "{{.Swarm.NodeAddr}}") >> ip.swarm
    # TODO: Write a shared data store

# docker stack deploy --composeo -file docker-compose.yml stackdemo
    # Deploys across the swarm 