#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/rancher/system-upgrade-controller/master/manifests/system-upgrade-controller.yaml
kubectl apply -f ./plans.yaml
watch kubectl get all -n system-upgrade
