#!/bin/bash
#This script need to be executed as a build step for every jenkins docker deployment
#Author @HariEnnekat

#can read it from buildjob itself w/o hard coding, uncomment and use below variable
#pattern=$docker_jobname

pattern="$1"

function cleanup {
        docker ps -a | grep $pattern | awk '{print $1}' | xargs docker stop
        sleep 1s
        docker ps -a | grep $pattern | awk '{print $1}' | xargs docker rm
        sleep 1s
}
container_check=`docker ps -a | grep $pattern | awk '{print $1}'`

if [ ! -z "$container_check" ]; then
cleanup
fi

image_check=`docker images -a | grep $pattern | awk '{print $3}'`
if [ ! -z $image_check ]; then
docker images -a | grep $pattern | awk '{print $3}' | xargs docker rmi
sleep 1s
fi

unused_image_check=`docker ps -a -f status=exited -q`
if [ ! -z "$unused_image_check" ]; then
        docker rm $(docker ps -a -f status=exited -q)
fi
