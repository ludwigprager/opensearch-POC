#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh

FOO_PID=""
function finish {
  echo killing $FOO_PID
  kill $FOO_PID
}
trap finish INT TERM EXIT



./kubectl port-forward --address 0.0.0.0 svc/opensearch-cluster-master 9200:9200 &
FOO_PID=$!
wait-for-port-forward 9200

ARTICLE_ID=$RANDOM$RANDOM
PROTOCOL=https
PROTOCOL=http



SVC=localhost

curl --fail -XGET -u 'admin:admin' "${PROTOCOL}://$SVC:9200/_aliases?pretty=true"

