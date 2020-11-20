.PHONY: redeploy

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
	ansible-galaxy role install -r requirements.yml --force && \
	ansible-galaxy collection install -r requirements.yml --force

## sync		: Sync from the upstream repository
sync:
	git remote add upstream https://github.com/geerlingguy/turing-pi-cluster.git && \
	git fetch upstream && \
	git checkout main && \
	git merge upstream/master

## help		: Show help
help: Makefile
	@sed -n 's/^##//p' $<

default: deploy
