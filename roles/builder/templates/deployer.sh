#!/bin/bash

echo "-> Starting deployer" | tee /var/log/htag/deploy.log
commit=$(git rev-parse --short HEAD)

echo "-> Commit $commit" | tee /var/log/htag/deploy.log

docker build . --no-cache -t $1:$commit | tee /var/log/htag/deploy.log

echo "-> Done" | tee /var/log/htag/deploy.log
