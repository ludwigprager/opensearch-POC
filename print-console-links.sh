#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh

echo
echo "whoami:                http://$(get-primary-ip):${INGRESS_PORT}/whoami"
echo "opensearch ui:         http://$(get-primary-ip):${INGRESS_PORT}/opensearch"
echo "opensearch-dashboards: http://$(get-primary-ip):${INGRESS_PORT}/opensearch-dashboards"
