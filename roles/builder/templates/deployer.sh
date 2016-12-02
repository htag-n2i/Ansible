#!/bin/bash
set -e
repository=run1.htag.fr:5000
echo "-> Starting deployer" | tee -a /var/log/htag/deploy.log
commit=$(git rev-parse --short HEAD)

echo "-> Commit $commit" | tee -a /var/log/htag/deploy.log

echo "-> Building image"
docker build -f ./DockerfileCI --no-cache -t $1-$2:$commit . | tee -a /var/log/htag/deploy.log

echo "-> Tagging image" | tee -a /var/log/htag/deploy.log
docker tag $1-$2:$commit $repository/$1-$2:$commit
echo "-> Push image"
docker push $repository/$1-$2:$commit
echo "-> Clean"
docker rmi $repository/$1-$2:$commit
echo "-> Deploying"
curl -s "http://run1.htag.fr:5001/$1/$2/$commit"
echo "-> Done" | tee -a /var/log/htag/deploy.log
