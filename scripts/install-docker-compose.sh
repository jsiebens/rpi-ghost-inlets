#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "Installing Docker Compose..."
apt-get install -y python3 python3-pip
pip3 install docker-compose

echo "============================= Docker Compose installation done"