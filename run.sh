#!/usr/bin/env bash

GAMS="/home/bernalde/gams/gams28.2_linux_x64_64_sfx/gams"
QSUB="/usr/local/bin/qsub"
if [ $USER == debernal ] ; then
    INSTANCEDIR=/home/debernal/Perspective/instances
    EXPDIR=/home/bernalde/Repositories/conic_disjunctive
else
    INSTANCEDIR=/home/bernalde/Repositories/conic_disjunctive/instances/kclustering
    EXPDIR=/home/bernalde/Repositories/conic_disjunctive
fi
TESTSET="clustering"
SKIPEXISTING=1   # whether to skip runs for which a trace file already exists
PARALLEL=1 # to use in Euler server by submitting runs to torque
GAMSOPTS="reslim=3600 threads=1 optcr=1e-5 iterlim=1e9 LO=3 nodlim=1000000"
# TODO memlimit?

INSTANCES=`cut -d" " -f1 ${TESTSET}.txt`

# run a solver/option-file combination on a particular instance
# $1 = instance
# $2 = solvername
# $3 = continuous subsolvername
# $4 = option file number
# $5 = binary option if NLP (0) of QCP (1)
function runinstance ()
{
   TRACEFILE=${TESTSET}.trc/$1.$2.$3.$4.trc

   if [ $SKIPEXISTING == 1 ] && [ -e $TRACEFILE ] ; then
      echo "Skip solver $2 subsolver $3 with option file $4 on instance $1"
      return
   fi

   echo "Run solver $2 subsolver $3 with option file $4 on instance $1"

   mkdir -p ${TESTSET}.trc
   mkdir -p ${TESTSET}.log

   # initialize trace files
   cat > $TRACEFILE <<EOF
* Trace Record Definition
* GamsSolve
* InputFileName,SolverName,OptionFile,Direction,NumberOfEquations,NumberOfVariables,NumberOfDiscreteVariables,NumberOfNonZeros,NumberOfNonlinearNonZeros,
* ModelStatus,SolverStatus,ObjectiveValue,ObjectiveValueEstimate,SolverTime,ETSolver,NumberOfIterations,NumberOfNodes,NumberOfDomainViolations
EOF


   if [ $USER == bernalde ] ; then
      if [[ $5 == 0 ]]; then
          sed -i '18s@.*@'"$GAMS ${INSTANCEDIR}/$1 MINLP=$2 NLP=$3 OPTFILE=$4 $GAMSOPTS LF=${TESTSET}.log/$1.$2.$3.$4.log O=${TESTSET}.log/$1.$2.$3.$4.lst TRACE=$TRACEFILE --TYPE=MINLP"'@' parallel.sh
      else
          sed -i '18s@.*@'"$GAMS ${INSTANCEDIR}/$1 MIQCP=$2 QCP=$3 OPTFILE=$4 $GAMSOPTS LF=${TESTSET}.log/$1.$2.$3.$4.log O=${TESTSET}.log/$1.$2.$3.$4.lst TRACE=$TRACEFILE --TYPE=MIQCP"'@' parallel.sh
      fi
      if [[ $PARALLEL == 1 ]] ; then
          sed -i '13s/.*/#PBS -N '"${TESTSET}.$1.$2.$3.$4"'/' parallel.sh
          sed -i '17s@.*@cd '"${EXPDIR}"'@' parallel.sh
          $QSUB parallel.sh
      else
          if [[ $5 == 0 ]]; then
              $GAMS ${INSTANCEDIR}/$1 MINLP=$2 NLP=$3 OPTFILE=$4 $GAMSOPTS LF=${TESTSET}.log/$1.$2.$3.$4.log O=${TESTSET}.log/$1.$2.$3.$4.lst TRACE=$TRACEFILE --TYPE=MINLP
          else
              $GAMS ${INSTANCEDIR}/$1 MIQCP=$2 QCP=$3 OPTFILE=$4 $GAMSOPTS LF=${TESTSET}.log/$1.$2.$3.$4.log O=${TESTSET}.log/$1.$2.$3.$4.lst TRACE=$TRACEFILE --TYPE=MIQCP
          fi
      fi
   fi
}

# run a solver/option-file combination on the set of instances
# $1 = solvername
# $2 = continuous subsolvername
# $3 = option file number
# $4 = binary option if NLP (0) of QCP (1)
function runsolveropt ()
{
   for i in $INSTANCES
   do
      runinstance $i $1 $2 $3 $4
   done
}

# run sbb subsolvers
runsolveropt sbb cplex 0 1
#runsolveropt sbb gurobi 0 1
#runsolveropt sbb ipopth 0 0
#runsolveropt sbb conopt 0 0
#runsolveropt sbb mosek 0 1
#runsolveropt sbb knitro 0 0

# run global minlp solvers
#runsolveropt baron baron 0 0
#runsolveropt scip scip 0 0
#runsolveropt antigone antigone 0 0

# run milp solvers
runsolveropt cplex cplex 0 1
#runsolveropt gurobi gurobi 0 1

# run MOSEK with and without OA
runsolveropt mosek mosek 0 1
runsolveropt mosek mosek 2 1

# run dicopt subsolvers
#runsolveropt dicopt2 conopt 2 0
#runsolveropt dicopt2 ipopth 2 0
#runsolveropt dicopt2 knitro 2 0
runsolveropt dicopt2 mosek 2 1

# run knitro
#runsolveropt knitro knitro 0 0


