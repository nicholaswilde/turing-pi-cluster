.PHONY: redeploy geting addrepos pre-commit-install

## deploy			: Deploy the k3s-cluster
deploy: site.yml
	ansible-playbook site.yml

## redeploy		: Reset and the deploy the k3s-cluster
redeploy:
	ansible-playbook reset.yml && \
	ansible-playbook site.yml

## reset			: Reset the k3s-cluster
reset: reset.yml
	ansible-playbook reset.yml

## requirements		: Install the requirements
requirements:
	ansible-galaxy collection install -r requirements.yml --force

## sync			: Sync from the upstream repository
sync:
	git remote add upstream https://github.com/geerlingguy/turing-pi-cluster.git && \
	git fetch upstream && \
	git checkout main && \
	git merge upstream/master

## geting			: Get the ingress ip address
geting:
	kubectl get all -n kube-system | grep '^service/traefik ' | awk '{print $$4}'

## addrepos		: Add all the Helm repositories
addrepos:
	helm repo add nicholaswilde https://nicholaswilde.github.io/helm-charts/ && \
	helm repo add k8s-at-home https://k8s-at-home.github.io/charts/ && \
	helm repo add mojo2600 https://mojo2600.github.io/pihole-kubernetes/

## pre-commit-install	:	Install pre-commint hooks
pre-commit-install:
	pre-commit install && \
	pre-commit install-hooks

## getvers		: Get the github versions
getvers:
	helm search repo nicholaswilde/booksonic && \
	helm search repo nicholaswilde/diun && \
	helm search repo nicholaswilde/gotify && \
	helm search repo k8s-at-home/homebridge && \
	helm search repo nicholaswilde/installer && \
	helm search repo nicholaswilde/papermerge && \
	helm search repo mojo2600/pihole && \
	helm search repo nicholaswilde/transmission

## help			: Show help
help: Makefile
	@sed -n 's/^##//p' $<

default: deploy
