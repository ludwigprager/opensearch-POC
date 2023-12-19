#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh


./40-start-a-k8s-cluster.sh
./50-install-opensearch.sh
./60-install-fluent-operator.sh
#./70-ingest-testdata.sh
./75.status.sh
./80-connect-to-dashboard.sh

