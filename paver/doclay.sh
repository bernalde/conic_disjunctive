#!/bin/bash

set -e

# use 3600s if solver failed
# reduce mintime to 0.1s, which fits better to local solvers
# disable examiner checks for feasibility and optimality
python3 ../src/paver/paver.py \
  clay_full_trc/*.trc \
  --failtime 3600 \
  --mintime 0.1 \
  --ccopttol inf \
  --ccfeastol inf \
  --writetext clay.txt \
  --ignoredualbounds
#  --writehtml clay.html \
