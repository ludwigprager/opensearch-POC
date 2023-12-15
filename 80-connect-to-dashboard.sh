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

./kubectl port-forward --address 0.0.0.0 svc/opensearch-dashboards 8333:5601 &
FOO_PID=$!
wait-for-port-forward 8333

INDICES_PATH="app/opensearch_index_management_dashboards#/indices"

sensible-browser http://localhost:8333/$INDICES_PATH || echo "http://$(get-primary-ip):8333/$INDICES_PATH"

sleep 5
echo press "<enter>" to terminate port-forwarding
read a
