#!/usr/bin/env bash

javac App.java

VERSION=$1
$(aws ecr --profile yanbin-root get-login --no-include-email --region us-east-1)
docker build -t 069762108088.dkr.ecr.us-east-1.amazonaws.com/test-java-app:$VERSION .
docker push 069762108088.dkr.ecr.us-east-1.amazonaws.com/test-java-app:$VERSION
docker rmi 069762108088.dkr.ecr.us-east-1.amazonaws.com/test-java-app:$VERSION