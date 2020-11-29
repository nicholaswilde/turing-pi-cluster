.PHONY: redeploy geting

## deploy		: Deploy the k3s-cluster
deploy: site.yml
	ansible-playbook site.yml

## redeploy	: Reset and the deploy the k3s-cluster
redeploy:
	ansible-playbook reset.yml && \
	ansible-playbook site.yml

## reset		: Reset the k3s-cluster
reset: reset.yml
	ansible-playbook reset.yml

## requirements	: Install the requirements
requirements:
	ansible-galaxy collection install -r requirements.yml --force

## sync		: Sync from the upstream repository
sync:
	git remote add upstream https://github.com/geerlingguy/turing-pi-cluster.git && \
	git fetch upstream && \
	git checkout main && \
	git merge upstream/master

## geting		: Get the ingress ip address
geting:
	kubectl get all -n kube-system | grep '^service/traefik ' | awk '{print $$4}'

## getvers	: Get the github versions
getvers:
	helm search repo nicholaswilde/installer && \
	helm search repo nicholaswilde/transmission && \
	helm search repo nicholaswilde/diun && \
	helm search repo nicholaswilde/gotify && \
	helm search repo k8s-at-home/unifi-poller && \
	helm search repo k8s-at-home/homebridge && \
	helm search repo mojo2600/pihole

## help		: Show help
help: Makefile
	@sed -n 's/^##//p' $<

default: deploy
