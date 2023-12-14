#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh

./kubectl apply -f manifest/set-max-map-count.yaml


./helm repo add opensearch https://opensearch-project.github.io/helm-charts/
./helm repo update
./helm upgrade --install \
  --version 2.17.0 \
  --wait \
  --values opensearch.values.yaml \
  opensearch opensearch/opensearch


# ist so vermutlich besser verständlich als mit --set
envsubst < dashboards.values.yaml.tpl > dashboards.values.yaml

./helm upgrade --install \
  --version 2.15.0 \
  --wait \
  --values dashboards.values.yaml \
  opensearch-dashboards opensearch/opensearch-dashboards





./kubectl apply -f manifest/whoami.yaml
./kubectl apply -f manifest/ingress.yaml


echo "waiting for opensearch-dashboards deployment to get ready"
./kubectl rollout status deployment opensearch-dashboards -n default --timeout=300s


