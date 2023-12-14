#!/usr/bin/env bash

export KUBECONFIG=${BASEDIR:-$(pwd)}/kubeconfig

CLUSTER="opensearch-poc"

export INGRESS_PORT="8633"

export DNS_DOMAIN=domain.k3d
