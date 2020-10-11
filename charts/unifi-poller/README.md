# unifi-poller
https://artifacthub.io/packages/helm/k8s-at-home/unifi-poller

Need to apply Ingress separately because enabling it through the Helm chart gives errors
```bash
$ helm repo add k8s-at-home https://k8s-at-home.com/charts/
$ helm repo update
$ helm install unifi-poller -f values.yml k8s-at-home/unifi-poller
$ kubectl apply -f ingress.yml
```
