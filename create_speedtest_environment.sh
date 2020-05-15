#!/usr/bin/env bash

set -eo pipefail

# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    fi
fi

if [ "${DISTRO}" == "Ubuntu" ]; then
  if docker version && docker-compose --version && systemctl is-active docker.service; then
    docker-compose up -d
  else
    sudo apt install --yes docker.io docker-compose
    sudo systemctl enable --now docker
  fi
fi
