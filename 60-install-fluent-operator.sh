#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh


./helm repo add fluent https://fluent.github.io/helm-charts

./helm upgrade --install fluent-operator fluent/fluent-operator \
  --version 2.5.0 \
  --wait \
  --values fluent-operator.values.yaml


