#!/usr/bin/env bash

# build.sh 1.02

ECR_REPO=069762108088.dkr.ecr.us-east-1.amazonaws.com/test-java-app
VERSION=$1

javac WebApp.java

#

$(aws ecr --profile yanbin-root get-login --no-include-email --region us-east-1)
docker build -t $ECR_REPO:$VERSION .
docker push $ECR_REPO:$VERSION
docker rmi $ECR_REPO:$VERSION