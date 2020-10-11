# unifi-poller
https://artifacthub.io/packages/helm/k8s-at-home/unifi-poller

Need to apply Ingress separately because enabling it through the Helm chart gives errors
```bash
$ helm repo add k8s-at-home https://k8s-at-home.com/charts/
$ helm repo update
$ helm install unifi-poller -f values.yml k8s-at-home/unifi-poller
$ kubectl apply -f ingress.yml
```
Check that ingress is working
```bash
$ kubectl get ingress -n monitoring
NAME                HOSTS                               ADDRESS         PORTS     AGE
unifi-poller        unifi-poller.192.168.1.202.nip.io   192.168.1.202   80, 443   76m
```
Browse to `unifi-poller.192.168.1.202.nip.io/metrics` to make sure it's working.
