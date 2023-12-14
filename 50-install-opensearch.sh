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

./kubectl apply -f manifest/set-max-map-count.yaml


./helm repo add opensearch https://opensearch-project.github.io/helm-charts/
./helm repo update
./helm upgrade --install \
  --version 2.17.0 \
  --wait \
  --values opensearch.values.yaml \
  opensearch opensearch/opensearch

# --set ingress.hosts[0]="opensearch.${DNS_DOMAIN}" \
#  --set plugins.security.disabled=true \
#  --set plugins.security.ssl.http.enabled=false \


# ist so vermutlich besser verständlich als mit --set
envsubst < dashboards.values.yaml.tpl > dashboards.values.yaml

./helm upgrade --install \
  --version 2.15.0 \
  --wait \
  --values dashboards.values.yaml \
  opensearch-dashboards opensearch/opensearch-dashboards





./kubectl apply -f manifest/whoami.yaml
#./kubectl apply -f manifest/keycloak.yaml
./kubectl apply -f manifest/ingress.yaml


echo "waiting for opensearch-dashboards deployment to get ready"
./kubectl rollout status deployment opensearch-dashboards -n default --timeout=300s



./kubectl port-forward --address 0.0.0.0 svc/opensearch-dashboards 8333:5601 &
FOO_PID=$!
wait-for-port-forward 8333



sensible-browser http://localhost:8333 || echo "http://$(get-primary-ip):8333"

sleep 5
echo press "<enter>" to terminate port-forwarding
read a
