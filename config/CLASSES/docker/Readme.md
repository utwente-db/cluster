# Docker

## Overview 

For a good overview, see [here](https://docs.docker.com/engine/understanding-docker/).

## Installation of docker on servers

    # Install repository
    apt-get update
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list
    apt-get update
    # Install docker
    apt-get install -y --no-install-recommends docker-engine
    # install docker compose
    curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-composesr/local/bin/docker-compose
    # add users to docker group
    usermod -a -G docker alyr
    # make directory 
    mkdir /local/docker
    # move the docker directory
    stop docker && mv /var/lib/docker /local/docker && echo "DOCKER_OPTS=\"-g /local/docker/\"" >> /etc/default/docker && start docker && rm -rf /var/lib/docker
    
## Start registry

    cd /local/docker
    mkdir registry
    # add user with password
    docker run --entrypoint htpasswd registry:2 -Bbn $USER $PASSWORD > auth/htpasswd
    # start registry at port 5000
    docker run -d -p 5000:5000 --restart=always --name registry -v /local/docker/registry:/var/lib/registry registry:2
    

## Pushing a image to the registry

To push a docker image $image to the registry, follow these steps:

    # login into registry
    docker login farm02.ewi.utwente.nl:5000
    # tag the imag as belonging 
    docker tag $image farm02.ewi.utwente.nl:5000/$image
    # actually push the image
    docker push farm02.ewi.utwente.nl:5000/$image
  
## Pulling an image from the registry

To pull a docker image $image from the registry, follow these steps:

    # login into registry
    docker login farm02.ewi.utwente.nl:5000
    # actually pull the image
    docker pull farm02.ewi.utwente.nl:5000/$image




    