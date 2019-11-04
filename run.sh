#!/usr/bin/env bash

GAMS="/home/bernalde/gams/gams28.2_linux_x64_64_sfx/gams"
if [ $USER == debernal ] ; then
    INSTANCEDIR=/home/debernal/Perspective/instances
    EXPDIR=/home/bernalde/Repositories/conic_disjunctive
else
    INSTANCEDIR=/home/bernalde/Repositories/conic_disjunctive/instances/socp
    EXPDIR=/home/bernalde/Repositories/conic_disjunctive
fi
TESTSET="random_socp"
SKIPEXISTING=0   # whether to skip runs for which a trace file already exists

GAMSOPTS="reslim=3600 threads=1 optcr=1e-5 iterlim=1e9 LO=3"
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
* ModelStatus,SolverStatus,ObjectiveValue,ObjectiveValueEstimate,SolverTime,ETSolver,NumberOfIterations,NumberOfNodes
EOF


   if [ $USER == bernalde ] ; then
      sed -i '13s/.*/#PBS -N '"${TESTSET}.$1.$2.$3.$4"'/' parallel.sh
      sed -i '17s@.*@cd '"${EXPDIR}"'@' parallel.sh
      # qsub parallel.sh
      if [ $5 == 0 ]; then
          $GAMS ${INSTANCEDIR}/$1 MINLP=$2 NLP=$3 OPTFILE=$4 $GAMSOPTS LF=${TESTSET}.log/$1.$2.$3.$4.log O=${TESTSET}.log/$1.$2.$3.$4.lst TRACE=$TRACEFILE
          sed -i '18s@.*@'"$GAMS ${INSTANCEDIR}/$1 MINLP=$2 NLP=$3 OPTFILE=$4 $GAMSOPTS LF=${TESTSET}.log/$1.$2.$3.$4.log O=${TESTSET}.log/$1.$2.$3.$4.lst TRACE=$TRACEFILE"'@' parallel.sh
      else
          $GAMS ${INSTANCEDIR}/$1 MIQCP=$2 QCP=$3 OPTFILE=$4 $GAMSOPTS LF=${TESTSET}.log/$1.$2.$3.$4.log O=${TESTSET}.log/$1.$2.$3.$4.lst TRACE=$TRACEFILE
          sed -i '18s@.*@'"$GAMS ${INSTANCEDIR}/$1 MIQCP=$2 QCP=$3 OPTFILE=$4 $GAMSOPTS LF=${TESTSET}.log/$1.$2.$3.$4.log O=${TESTSET}.log/$1.$2.$3.$4.lst TRACE=$TRACEFILE"'@' parallel.sh

      fi
   fi
}

# run a solver/option-file combination on the set of instances
# $1 = solvername
# $2 = continuous subsolvername
# $3 = option file number
function runsolveropt ()
{
   for i in $INSTANCES
   do
      runinstance $i $1 $2 $3
   done
}

# run all
runsolveropt sbb ipopth 0 1
#runsolveropt sbb ipopth 0 0
