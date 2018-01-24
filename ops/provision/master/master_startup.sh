#!/bin/bash

# Sets the Swarm ports 
    ufw allow 22/tcp
    ufw allow 2376/tcp 
    ufw allow 2377/tcp
    ufw allow 7946/tcp
    ufw allow 7946/udp
    ufw allow 4789/udp

# Docker registry port
    ufw allow 5000/tcp

# Refreshs the firewall
    ufw --force reload
    ufw --force enable

# Restart Docker to be sure
    systemctl restart docker

# Create as the swarm master here 
    # docker swarm init --advertise-addr <MANAGER-IP>

# Return the token and IP address (needed by nodes)
    # docker swarm join-token -q worker
    # docker info --format "{{.Swarm.NodeAddr}}"

# Create a resgistry mirror 
    # See url saved to bear to reduce network traffic 

# Docker compose can be stood up 
    # TODO - This will download the images to the mirror, this resolves speed and security

# docker stack deploy --composeo -file docker-compose.yml stackdemo
    # Deploys across the swarm 