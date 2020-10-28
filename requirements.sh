#!/bin/bash
ansible-galaxy role install -r requirements.yml --force
ansible-galaxy collection install -r requirements.yml --force
