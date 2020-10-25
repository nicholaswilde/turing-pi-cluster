#!/bin/bash

kubectl create ns homebridge
helm install homebridge k8s-at-home/homebridge -n homebridge
kubectl apply -f ./ingress.yaml
