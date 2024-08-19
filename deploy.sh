#!/bin/env bash
set -euo pipefail

# Поднимает 5 примерных нодов с помощью `kind` и затем запускает deployment
# ./deploy.sh -d -- удалить ноды и кластер

# dependencies: kind, kubectl, docker,

KUBECTL="kubectl --context kind-kind"

# check flags
while getopts "d" option; do
  case $option in
    d) DELETE_DEPLOYMENT=true ;;
    *) ;;
  esac
done

# bring down
if [[ -n ${DELETE_DEPLOYMENT:+x} ]]; then
  $KUBECTL delete -f ./test-task.yaml || true
  kind delete cluster
  exit 0
fi

# bring up
kind create cluster --config ./kind_cluster.yaml || true
$KUBECTL apply -f ./test-task.yaml
$KUBECTL rollout status deployment
