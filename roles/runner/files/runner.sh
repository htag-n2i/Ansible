#!/bin/bash

app=$1
branch=$2
version=$3

whoami

echo "-> Pulling image" | tee -a /var/log/htag/deploy.log

docker pull run1.htag.fr:5000/$app-$branch:$version 2>&1 | tee -a /var/log/htag/deploy.log
docker tag run1.htag.fr:5000/$app-$branch:$version $app-$branch:$version 2>&1 | tee -a /var/log/htag/deploy.log
docker rmi run1.htag.fr:5000/$app-$branch:$version 2>&1 | tee -a /var/log/htag/deploy.log

echo "-> Removing old image" | tee -a /var/log/htag/deploy.log

mkdir -p /srv/htag-runner/applications/$app/$branch/
pushd /srv/htag-runner/applications/$app/$branch/

oldVersion=$(cat version)

docker rm -f $app-$branch-$oldVersion 2>&1 | tee -a /var/log/htag/deploy.log

echo "-> Starting new image" | tee -a /var/log/htag/deploy.log

port=$(cat port)

docker run -d -p $port --env-file ./env --name=$app-$branch-$version $app-$branch:$version 2>&1 | tee -a /var/log/htag/deploy.log 

echo $version > version | tee -a /var/log/htag/deploy.log

echo "-> Done !"
