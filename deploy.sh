#!/bin/env bash
set -euo pipefail

# Поднимает 3 примерных нода и затем запускает кластер
# -d -- удалить ноды и кластер

# kubectl="kubectl"
kubectl="minikube kubectl --"  # так как я использую minikube

while getopts "d" option; do
  case $option in
    d) DELETE_DEPLOYMENT=true ;;
    *) ;;
  esac
done

if [[ -n ${DELETE_DEPLOYMENT:+x} ]]; then
  for f in ./node-*.yaml; do
    $kubectl delete -f $f;
  done
  $kubectl delete -f ./test-task.yaml

  exit 0
fi

for f in ./node-*.yaml; do
  $kubectl create -f $f;
done

$kubectl create -f ./test-task.yaml
