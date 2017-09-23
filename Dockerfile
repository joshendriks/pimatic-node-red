# Set the base image
FROM joshendriks/raspberry-pi2-pimatic

RUN mkdir /home/node-red
RUN cd /home/node-red && npm install node-red@0.17.5
RUN mkdir /home/pimatic-app/node_modules/pimatic-node-red

# Enable pimatic-node-red in config
RUN sed -i "s/\"mobile-frontend\"/\"mobile-frontend\" },{ \"plugin\": \"node-red\"/g" /home/pimatic-app/config.json

# Expose port 80 8000
EXPOSE 80 8000

#### command to create symlink in mounted directory to location of node-red
#ln -s /home/node-red/node_modules /home/pimatic-app/node_modules/pimatic-node-red/node_modules

#### command to run the docker image
#docker run -p 80:80 -p 8000:8000 -i -t -v D:/Documents/pimatic-node-red:/home/pimatic-app/node_modules/pimatic-node-red pimatic-node-red