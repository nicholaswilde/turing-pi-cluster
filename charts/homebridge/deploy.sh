#!/bin/bash

if ! command -v kubectl &> /dev/null; then
    echo 'kubectl is not installed'
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo 'helm is not installed'
    exit 1
fi

kubectl apply -f namespace.yaml
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
helm install homebridge k8s-at-home/homebridge -n homebridge -f values.yaml
watch kubectl get all -n homebridge
