#!/bin/sh

# Set the number of nodes and processes per node
#PBS -l nodes=1:ppn=1

# Set max wallclock time
#PBS -l walltime=2:00:00

# Set maximum memory
#PBS -l mem=3gb

# Set name of job
#PBS -N random_socp.random_5_5_5_HRC_9.gms.cplex.cplex.0

# Use submission environment
#PBS -V
cd /home/bernalde/Repositories/conic_disjunctive
/home/bernalde/gams/gams28.2_linux_x64_64_sfx/gams /home/bernalde/Repositories/conic_disjunctive/instances/socp/random_5_5_5_HRC_9.gms MIQCP=cplex QCP=cplex OPTFILE=0 reslim=3600 threads=1 optcr=1e-5 iterlim=1e9 LO=3 nodlim=1000000 LF=random_socp.log/random_5_5_5_HRC_9.gms.cplex.cplex.0.log O=random_socp.log/random_5_5_5_HRC_9.gms.cplex.cplex.0.lst TRACE=random_socp.trc/random_5_5_5_HRC_9.gms.cplex.cplex.0.trc --TYPE=MIQCP
