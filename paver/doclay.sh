#!/bin/bash
set -e
# use 3600s if solver failed
# reduce mintime to 0.1s, which fits better to local solvers
# disable examiner checks for feasibility and optimality
python3 ../src/paver/paver.py \
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
  clay_full_trc/Mc.mosek.trc \
  clay_full_trc/Mc.sbbmosek.trc \
  clay_full_trc/Mc.sbbknitro.trc \
  ../solu/clay.solu \
  --failtime 3600 \
  --mintime 0.1 \
  --ccopttol inf \
  --ccreltol 1e03 \
  --ccabstol 1e-7 \
  --writetext clay.txt \
  --writehtml clay.html \
  --gaptol 0.001 \
  --novirt \
  --extendedprofiles \
  --nocheckinstanceattr \
  --nocheckinstanceattr \
  --numpts 2000
  # --ignoredualbounds \


#   rsyn_full_trc/*.trc \
#   syn_full_trc/*.trc \
#   rsyn_no_t_full_trc/*.trc \
#   syn_no_t_full_trc/*.trc \
#   process_full_trc/*.trc \
#   exp_full_trc/*.trc \
#   logistic_full_trc/*.trc \
#   kclustering_full_trc/*.trc \
#   socp_full_trace/*.trc \
#   clay_full_trc/HRc.cplex.trc \
#   clay_full_trc/M.cplex.trc \
#   clay_full_trc/HRc.mosek.trc \
#   clay_full_trc/M.mosek.trc \
#   clay_full_trc/M.baron.trc \
#   clay_full_trc/HR.baron.trc \
#   clay_full_trc/HRc.baron.trc \
#   clay_full_trc/M.knitro.trc \
#   clay_full_trc/HR.knitro.trc \
#   clay_full_trc/HRc.knitro.trc \
#   clay_full_trc/M.sbbknitro.trc \
#   clay_full_trc/HR.sbbknitro.trc \
#   clay_full_trc/HRc.sbbknitro.trc \
#   clay_full_trc/HRc.sbbmosek.trc \
#   clay_full_trc/M.sbbmosek.trc \
#   clay_full_trc/Mc.mosek.trc \
#   clay_full_trc/Mc.sbbmosek.trc \
#   clay_full_trc/Mc.sbbknitro.trc \


#   rsyn_full_trc/*sbb*.trc \
#   syn_full_trc/*sbb*.trc \
#   rsyn_no_t_full_trc/*sbb*.trc \
#   syn_no_t_full_trc/*sbb*.trc \
#   process_full_trc/*sbb*.trc \
#   exp_full_trc/*sbb*.trc \
#   logistic_full_trc/*sbb*.trc \
#   kclustering_full_trc/*sbb*.trc \
#   socp_full_trace/*sbb*.trc \
#   clay_full_trc/*sbb*.trc \
