#!/usr/bin/env bash


function cluster-exists() {
  local cluster_name=$1
  #local K3D=$(get-k3d-path)
  local K3D=${BASEDIR}/k3d

  # need a blank after name. Else prefix would work, too.
  COUNT=$(${K3D} cluster list | grep ^${cluster_name}\  | wc -l)
  if [[ $COUNT -eq 0 ]]; then
    # 1 = false
    return 1
  else
    # 0 = true
    return 0
  fi
}

export -f cluster-exists





get-primary-ip() {
  # no hostname -I on macOS
  if [ "$(uname -o)" == Darwin ]; then
    local PRIMARY_IP=$(ifconfig en0 | awk '/inet / {print $2; }' | egrep -v 127.0.0.1 | head -1)
  else
    local PRIMARY_IP=$(hostname -I | cut -d " " -f1)
  fi
  printf ${PRIMARY_IP}
}
export -f get-primary-ip

function wait-for-port-forward() {
  local localport=$1
  local start=$(date +%s)
  # wait for $localport to become available
  while ! nc -vz localhost $localport > /dev/null 2>&1 ; do
    # echo sleeping
    sleep 0.1
    now=$(date +%s)
    elapsed=$(($now-$start))
    if [[ $elapsed -gt 5 ]]; then
      echo wait-for-port-forward timed out after 5 seconds
      return
    fi
  done
}

