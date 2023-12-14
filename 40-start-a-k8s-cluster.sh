#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh


# install k3d
if [[ ! -f ./k3d ]]; then
  export K3D_INSTALL_DIR=${BASEDIR:-$(pwd)}
  export USE_SUDO='false'
  export PATH=$PATH:${BASEDIR} # k3d install fails otherwise
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.6.0 bash
fi

# install kubectl
if [[ ! -f ./kubectl ]]; then
  KUBECTL_VERSION=1.28.3
  curl -LO https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
  chmod +x kubectl
fi


# install helm
if [[ ! -f ./helm ]]; then

  HELM_VERSION=3.13.1
  curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
  tar zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz
  mv linux-amd64/helm .
  chmod +x helm
fi


  if ! cluster-exists $CLUSTER; then

    ./k3d cluster create --api-port 6550 -p "${INGRESS_PORT}:80@loadbalancer"            $CLUSTER

  fi


echo waiting for traefik jobs to complete
./kubectl wait -n kube-system job.batch/helm-install-traefik-crd --for=condition=complete --timeout=600s
./kubectl wait -n kube-system job.batch/helm-install-traefik     --for=condition=complete --timeout=600s
