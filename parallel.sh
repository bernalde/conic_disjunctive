#!/bin/sh

# Set the number of nodes and processes per node
#PBS -l nodes=1:ppn=1

# Set max wallclock time
#PBS -l walltime=2:00:00

# Set maximum memory
#PBS -l mem=3gb

# Set name of job
#PBS -N syn.Syn40M04HC.gms.mosek.mosek.2

# Use submission environment
#PBS -V
cd /home/bernalde/Repositories/conic_disjunctive
/home/bernalde/gams/gams28.2_linux_x64_64_sfx/gams /home/bernalde/Repositories/conic_disjunctive/instances/syn/Syn40M04HC.gms MINLP=mosek NLP=mosek OPTFILE=2 reslim=3600 threads=1 optcr=1e-5 iterlim=1e9 LO=3 nodlim=1000000 LF=syn.log/Syn40M04HC.gms.mosek.mosek.2.log O=syn.log/Syn40M04HC.gms.mosek.mosek.2.lst TRACE=syn.trc/Syn40M04HC.gms.mosek.mosek.2.trc --TYPE=MINLP
