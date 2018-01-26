# Things to do

* Complete writing the ping.sh tests to ensure that all the droplets are not exposed 
* Build the master seperately from the nodes
* Refactor the http.sh health checks to dynamically pick up new record entries
* Dymanically pick up the droplet ids and ping them to ensure not directly exposed
* Dynanically pick up the load balancer ids and pint to ensure directly exposed 
* Dynamically scan the ports of the Load balancers to ensure the right ports are open
* Seperate out the deployment of the application from the VM images
* Refactor the references to the state dir in the .ymal file
* Remove the use of the .id and .ids file and write code to read directly manifest
* Secure all HTTP end points using HTTPS both fopr the master and the application
* Manually try and get the Docker Swarm up and running using the script online
* Understand how to get Gerkin tests running against the API
* Look a creating a seperate database and attach a Digital Ocean volume 
* Look at enabling monitoring (subject to cost)
* Seperate out the TFState for different environments 
* Work out how how to do canary deployments without destroying the existing infarstructure
* Add in the ability to have multiple masters in the stack
* Move certain scripts out of shell and into python 

[![CircleCI](https://circleci.com/gh/delineateio/delineateio.api/tree/master.svg?style=svg)](https://circleci.com/gh/delineateio/delineateio.api/tree/master)


## Local Dependencies

### CircleCI CLI

curl -o /usr/local/bin/circleci https://circle-downloads.s3.amazonaws.com/releases/build_agent_wrapper/circleci && chmod +x /usr/local/bin/circleci

### Digital Ocean CLI 

### Packer 


### Terraform 



