
export KUBECONFIG=${BASEDIR:-$(pwd)}/kubeconfig

CLUSTER="opensearch-poc"

export INGRESS_PORT="8633"

export DNS_DOMAIN=domain.k3d

export HELM_CACHE_HOME=${BASEDIR:-$(pwd)}/.helm/cache
export HELM_CONFIG_HOME=${BASEDIR:-$(pwd)}/.helm/config
export HELM_DATA_HOME=${BASEDIR:-$(pwd)}/.helm/data
