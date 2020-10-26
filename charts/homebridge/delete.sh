#!/bin/bash

helm delete homebridge
kubectl delete pvc homebridge-pvc -n homebridge
kubectl delete pv homebridge-pv-nfs -n homebridge
kubectl delete namespace homebridge
