#!/bin/env bash
set -euo pipefail

# Поднимает 3 примерных нода и затем запускает кластер.
# ./deploy.sh -d -- удалить ноды и кластер

# kubectl="kubectl"
kubectl="minikube kubectl --"  # так как я использую minikube

# check flags
while getopts "d" option; do
  case $option in
    d) DELETE_DEPLOYMENT=true ;;
    *) ;;
  esac
done

if [[ -n ${DELETE_DEPLOYMENT:+x} ]]; then
  for f in ./node-*.yaml; do
    $kubectl delete -f $f || true  # ignore failure
  done
  $kubectl delete -f ./test-task.yaml || true

  exit 0
fi

# create nodes
for f in ./node-*.yaml; do
  $kubectl create -f $f;
done

# apply deployment
$kubectl apply -f ./test-task.yaml
