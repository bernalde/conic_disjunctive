#!/bin/bash

set -e

# use 3600s if solver failed
# reduce mintime to 0.1s, which fits better to local solvers
# disable examiner checks for feasibility and optimality
python3 ../src/paver/paver.py \
  logistic_full_trc/*.trc \
  ../solu/logistic.solu \
  --failtime 3600 \
  --mintime 0.1 \
  --ccopttol inf \
  --ccreltol 1e03 \
  --ccabstol 1e-7 \
  --writetext logistic.txt \
  --writehtml logistic.html \
  --gaptol 0.001 \
  --novirt \
  --extendedprofiles \
  --nocheckinstanceattr \
  --numpts 50 \
  --nocheckinstanceattr \
  # --ignoredualbounds \

