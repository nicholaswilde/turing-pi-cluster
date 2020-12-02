# Turing Pi Cluster - 7-node K3s Raspberry Pi Cluster
[![GitHub](https://img.shields.io/github/license/nicholaswilde/turing-pi-cluster)](./LICENSE.md)
[![CI](https://github.com/nicholaswilde/turing-pi-cluster/workflows/CI/badge.svg?branch=main&event=push)](https://github.com/nicholaswilde/turing-pi-cluster/actions?query=workflow%3ACI)
[![Ansible Lint](https://github.com/nicholaswilde/turing-pi-cluster/workflows/Ansible%20Lint/badge.svg?branch=main)](https://github.com/nicholaswilde/turing-pi-cluster/actions?query=workflow%3A%22Ansible+Lint%22)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fnicholaswilde%2Fturing-pi-cluster.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fnicholaswilde%2Fturing-pi-cluster?ref=badge_shield)

<p align="center"><a href="https://www.youtube.com/watch?v=kgVz4-SEhbE"><img src="images/turing-pi-cluster-hero.jpg?raw=true" width="500" height="auto" alt="Turing Pi - Raspberry Pi Compute Module Cluster" /></a></p>

An Ansible playbook for my [Turing Pi](https://turingpi.com/) cluster.

This repository is a a fork of [Jeff Geerling's](https://github.com/geerlingguy) [Turing Pi Cluster](https://github.com/geerlingguy/turing-pi-cluster).

See my [Artifact Hub](https://artifacthub.io/packages/search?repo=nicholaswilde) for my Helm charts.

The following deployments are available in this repository:
  - [Booksonic](https://booksonic.org/)
  - [Diun](https://crazymax.dev/diun/)
  - [Gotify](https://gotify.net/)
  - [Homebridge](https://homebridge.io/)
  - [Installer](https://github.com/jpillora/installer)
  - [Papermege](https://www.papermerge.com/)
  - [Pi-hole](https://pi-hole.net/)
  - [Transmission](https://transmissionbt.com/)

## Compatibility

This cluster configuration has been tested with the following Raspberry Pi and OS combinations:

  - [X] Raspberry Pi Compute Module 3+ and HypriotOS

Other models of Raspberry Pi and Compute Modules may or may not work, but the main thing you need is a cluster with at least 7 GB of RAM and at least 12 available CPU cores (every current Pi has 4 CPU cores), otherwise not all of the software will be able to run well.

This configuration will _definitely not_ run on the Pi Zero, or on Pis older than the Raspberry Pi 2 model B.

## Usage

First, you need to make sure you have K3s running on your Pi cluster.

When you run the K3s Ansible playbook, make sure you have `extra_server_args: "--node-taint k3s-controlplane=true:NoExecute"` in your K3s `group_vars/all.yml`, so pods are not scheduled on the master node, and that all your nodes have unique hostnames (e.g. on Pi OS, run `sudo hostnamectl set-hostname worker-01` to set a Pi to `worker-01`).

Then, you can deploy _all_ the applications configured in this repository with the `site.yml` playbook:

  1. Make sure you have [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed.
  2. Install Ansible requirements:

     ```bash
     $ make requirements
     # or
     $ ansible-galaxy collection install -r requirements.yml
     ```

     These commands can be consolidated into one `ansible-galaxy install` command once Ansible 2.10 is released.

  3. Copy the `example.hosts.yml` inventory file to `hosts.yaml`. Make sure it has the `master` and `nodes` configured correctly.
  4. Edit the `ingress_server_ip` in `group_vars/all.yml` and set them each to an IP address of one of the nodes. (Change any other variables in that file as necessary.)
     If you have Traefik installed,  you can get the Ingress IP by running `make geting`
  5. Run the playbook:

     ```bash
     $ make deploy
     # or
     $ ansible-playbook site.yml
     ```

Once that's done, there will be variety of applications running on your cluster, for example:

| Software | Address | Notes |
| -------- | ------- | ------- |
| Booksonic | http://booksonic.192.168.1.201.nip.io | Default login is `admin/admin` |
| Gotify | http://gotify.192.168.1.201.nip.io | Default login is `admin/admin` |
| Homebridge | http://homebridge.192.168.1.201.nip.io | Default login is `admin/admin` |
| installer | http://installer.192.168.1.201.nip.io | N/A |
| Papermerge | http://papermerge.192.168.1.201.nip.io | Default login is `admin/admin` |
| Pi-hole | http://pi.hole/ | See [pihole role README](./roles/pihole/README.md) |
| Transmission | http://homebridge.192.168.1.201.nip.io | Default login is `pirate/hypriot` |

The exact URLs will vary in your cluster; refer to the output of the Ansible playbook, which lists each service's exact URL.

### Pre-commit hook

If you want to automatically lint the files with a pre-commit hook, make sure you
[install the pre-commit binary](https://pre-commit.com/#install), and add a [.pre-commit-config.yaml file](./.pre-commit-config.yaml)
to your project. Then run:

```bash
pre-commit install
pre-commit install-hooks
```

## Caveats

They are a'plenty.

First of all, the configurations in this repository were built for local demonstration purposes. There are some things that are insecure (like storing some database passwords in plain text), and other things that are just plain crazy (like trying to run all the above things on one tiny Pi-based cluster!).

There are a few architectural decisions that were made that are great for 'day one' setup, but if you tried to flex K3s' muscle and drop/replace nodes while the cluster is running, you'd likely start running into some, shall we say, 'fun' problems.

For example, the MariaDB PVCs are tied to the local node on which they were first deployed, and if you do something that results in the MariaDB Deployment to change nodes for the deployed Pod... you may run into warnings like `FailedScheduling: 3 node(s) had volume node affinity conflict.`

Therefore, if you want to use this project as a base, and are planning on doing anything more than a local demo cluster, you are responsible for making changes to support a more production-ready setup, with better security and better configuration of persistent volumes and multi-pod scalability.

To do these things _correctly_ with Kubernetes takes a lot of work. It's usually _very_ easy—maybe deceptively easy—to get something working. It's harder to get it working reliably in an automated fashion when rebuilding the cluster from scratch (that's about the level where this repository is). And harder still is getting it working reliably with easy maintenance, fault-tolerance, and scalability.

Kubernetes is no substitute for a thorough knowledge of system architecture and engineering!

## Resetting the cluster

You'll likely want to blow away all the changes you've made in a cluster and start fresh every now and then. If you made a mistake, or something broke terribly, that problem goes away. Or, if you want to make sure you've automated the entire cluster build properly, it's best practice to rebuild a cluster frequently.

Regardless of the reason, here's how to quickly wipe the cluster clean (without re-flashing all the Raspberry Pis from scratch):

  1. In the `k3s-ansible` repository directory (which you used to set up the cluster), run:

     ```
     ansible-playbook -i hosts.yaml reset.yml
     ```

     This command will likely have a few failures relating to files that can't be cleaned up until after a reboot.

  2. Reboot the Raspberry Pis (in the same directory):

     ```
     ansible -i hosts.yaml all -m reboot -b
     ```

  3. Run the reset playbook a second time, to clean up the stragglers:

     ```
     ansible-playbook -i hosts.yaml reset.yml
     ```

  4. Re-install K3s on the cluster:

     ```
     ansible-playbook -i hosts.yaml site.yml
     ```

Now you can go back to the steps above under 'Usage' to set up applications inside the cluster!

> Important note: Any files that were downloaded for this repository, like the monitoring repository, still exist in the `pirate` (HypriotOS) or `pi` (Raspberry Pi OS) user's home directory. For a more complete reset, also delete all those files and directories. Or to go thermonuclear, re-flash all the Pi's eMMC or microSD cards.

## Todo
  - [ ] Uncomment Pi-hole

## Author

The repository was created in 2020 by [Jeff Geerling](https://www.jeffgeerling.com), who writes [Ansible for DevOps](https://www.ansiblefordevops.com) and [Ansible for Kubernetes](https://www.ansibleforkubernetes.com) and modified by [Nicholas Wilde](https://about.me/nicholas.wilde).
