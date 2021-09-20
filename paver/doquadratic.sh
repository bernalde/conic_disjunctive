#!/bin/bash

set -e

# use 3600s if solver failed
# reduce mintime to 0.1s, which fits better to local solvers
# disable examiner checks for feasibility and optimality
python3 ../src/paver/paver.py \
  kclustering_full_trc/*.trc \
  ../solu/kClustering.solu \
  socp_full_trace/*.trc \
  ../solu/socp.solu \
  clay_full_trc/HRc.cplex.trc \
  clay_full_trc/M.cplex.trc \
  clay_full_trc/HRc.mosek.trc \
  clay_full_trc/M.mosek.trc \
  clay_full_trc/M.baron.trc \
  clay_full_trc/HR.baron.trc \
  clay_full_trc/HRc.baron.trc \
  clay_full_trc/M.knitro.trc \
  clay_full_trc/HR.knitro.trc \
  clay_full_trc/HRc.knitro.trc \
  clay_full_trc/M.sbbknitro.trc \
  clay_full_trc/HR.sbbknitro.trc \
  clay_full_trc/HRc.sbbknitro.trc \
  clay_full_trc/HRc.sbbmosek.trc \
  clay_full_trc/M.sbbmosek.trc \
  ../solu/clay.solu \
  ../solu/clustering.solu \
  ../solu/socp.solu \
  --failtime 3600 \
  --mintime 0.1 \
  --ccopttol inf \
  --ccreltol 1e03 \
  --ccabstol 1e-7 \
  --writetext quadratic.txt \
  --gaptol 0.001 \
  --novirt \
  --nocheckinstanceattr \
  --writehtml quadratic.html \
  --nocheckinstanceattr \
  --extendedprofiles \
  --numpts 2000 \
#   --ignoredualbounds \