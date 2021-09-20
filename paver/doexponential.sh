#!/bin/bash

set -e

# use 3600s if solver failed
# reduce mintime to 0.1s, which fits better to local solvers
# disable examiner checks for feasibility and optimality
python3 ../src/paver/paver.py \
  rsyn_full_trc/*.trc \
  syn_full_trc/*.trc \
  rsyn_no_t_full_trc/*.trc \
  syn_no_t_full_trc/*.trc \
  ../solu/syn.solu \
  process_full_trc/*.trc \
  ../solu/process.solu \
  exp_full_trc/*.trc \
  ../solu/exp.solu \
  logistic_full_trc/*.trc \
  ../solu/logistic.solu \
  --failtime 3600 \
  --mintime 0.1 \
  --ccopttol inf \
  --ccreltol 1e03 \
  --ccabstol 1e-7 \
  --writetext exponential.txt \
  --writehtml exponential.html \
  --gaptol 0.001 \
  --novirt \
  --extendedprofiles \
  --nocheckinstanceattr \
  --numpts 2000 \
  --nocheckinstanceattr \
  # --ignoredualbounds \

