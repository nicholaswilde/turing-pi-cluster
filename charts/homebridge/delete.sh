#!/bin/bash

if ! command -v kubectl &> /dev/null; then
    echo 'kubectl is not installed'
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo 'helm is not installed'
    exit 1
fi

helm delete homebridge
kubectl delete pvc homebridge-pvc -n homebridge
kubectl delete pv homebridge-pv-nfs -n homebridge
kubectl delete namespace homebridge
