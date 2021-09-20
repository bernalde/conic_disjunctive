#!/bin/bash

set -e

# use 3600s if solver failed
# reduce mintime to 0.1s, which fits better to local solvers
# disable examiner checks for feasibility and optimality
python3 ../src/paver/paver.py \
  kclustering_full_trc/*.trc \
  ../solu/kClustering.solu \
  --failtime 3600 \
  --mintime 0.1 \
  --ccopttol inf \
  --ccreltol 1e03 \
  --ccabstol 1e-7 \
  --writetext kclustering.txt \
  --writehtml kclustering.html \
  --gaptol 0.001 \
  --novirt \
  --nocheckinstanceattr \
  --numpts 50 \
  --nocheckinstanceattr \
  --extendedprofiles \
#   --ignoredualbounds \

