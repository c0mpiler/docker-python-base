#!/bin/bash
set -e

pip install --upgrade pip
pip install --upgrade --no-cache-dir omxware

clear
cd /opt

exec "$@"
