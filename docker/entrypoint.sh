#!/bin/bash
set -e

source /opt/conda/etc/profile.d/conda.sh

conda activate tv

if [ $# -eq 0 ]; then
    exec /bin/bash
else
    exec "$@"
fi
