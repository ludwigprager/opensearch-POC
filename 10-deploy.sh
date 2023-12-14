#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh

#docker build \
#  -f container/Dockerfile \
#  -t ${POC_IMAGE} .

./40-start-a-k8s-cluster.sh
./50-install-opensearch.sh
#./50-install-postgres-operator.sh
#./60-create-postgres-cluster.sh
#./70-test.sh
