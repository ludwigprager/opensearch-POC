#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh

./kubectl apply -f secret.yaml

./helm repo add fluent https://fluent.github.io/helm-charts

./helm upgrade --install fluent-operator fluent/fluent-operator \
  --version 2.5.0 \
  --wait \
  --values fluent-operator.values.yaml


#./kubectl get clusteroutputs.fluentd.fluent.io fluentd-output-opensearch -o yaml > clusteroutputs.fluentd.fluent.io.vorher.yaml

kubectl patch clusteroutputs.fluentd.fluent.io fluentd-output-opensearch \
  --type=merge --patch-file patch-file.yaml

#./kubectl get clusteroutputs.fluentd.fluent.io fluentd-output-opensearch -o yaml > clusteroutputs.fluentd.fluent.io.nachher.yaml

#./kubectl delete sts fluentd 
