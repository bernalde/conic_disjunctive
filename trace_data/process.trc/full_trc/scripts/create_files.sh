# Script to generate single trace file from separate files out of GAMS
FILE="process"
declare -a Problems=("bm" "bmc" "hrc" "hre" "hrl" "hrs")
declare -a Solvers=("baron" "antigone" "mosek" "knitro" "scip")
for prob in ${Problems[@]}; do
  for sol in ${Solvers[@]}; do
    echo "Processing problem ${prob} with solver ${sol}"
    # Join all files corresponding to the solvers in a single trace file
    cat ../../../${FILE}.trc/*${prob}.*.${sol}.${sol}.*.trc > ../${prob}.${sol}.trc
    # Remove all lines starting with * and space
    sed -i '/^*/d' ../${prob}.${sol}.trc
    # Remove problem type .gms from problem name
    sed -i "s/_${prob}.gms//I" ../${prob}.${sol}.trc
    # Rename the lines to replace the solver with solverproblem, e.g., baron->baronBM
    sed -i "s/${sol}/${sol}${prob}/I" ../${prob}.${sol}.trc
    # Replace hrs with HR for it to match logistic
    sed -i 's/hrs,/HR,/' ../${prob}.${sol}.trc
    # Replace bm with BM for it to match logistic
    sed -i 's/bm,/BM,/' ../${prob}.${sol}.trc
    # Replace hrc with HRc for it to match logistic
    sed -i 's/hrc,/HRc,/' ../${prob}.${sol}.trc
    # Replace bmc with BMc for it to match logistic
    sed -i 's/bmc,/BMc,/' ../${prob}.${sol}.trc
    # Paste trace specifications at the beginning of the file
    cat trc_specs.txt ../${prob}.${sol}.trc > ../${prob}.${sol}.modified
    mv ../${prob}.${sol}.modified ../${prob}.${sol}.trc
  done
done
# Remove all "empty" files with only the header (5 lines)
find ../ -maxdepth 1 -type f -exec awk -v x=5 'NR==x{exit 1}' {} \; -exec rm -f {} \;