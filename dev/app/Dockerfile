FROM node:boron

# Copies in the files 
    COPY /src /usr/app
    WORKDIR /usr/app


# Installs the apps dependencies 
    RUN npm install
    RUN npm install express --save
    RUN npm install body-parser --save
    

# Expose the port
    EXPOSE 8080


# Cmd to be run
    CMD [ "npm", "start" ]
