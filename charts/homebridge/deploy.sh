#!/bin/bash

kubectl apply -f namespace.yaml
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
helm install homebridge k8s-at-home/homebridge -n homebridge -f values.yaml
watch kubectl get all -n homebridge
