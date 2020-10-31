#!/bin/bash

helm repo add k8s-at-home https://k8s-at-home.com/charts/
helm repo update
helm install unifi-poller -f values.yml k8s-at-home/unifi-poller -n monitoring
