# Script to generate single trace file from separate files out of GAMS
FILE="syn"
# declare -a Problems=("BM" "BMC" "HA" "HC" "HD" "HL" "HR" "HS")
declare -a Problems=("BM" "BMC" "HA" "HC" "HD" "HL" "HS")
declare -a Solvers=("baron" "antigone" "mosek" "knitro" "scip" "cplex")
for prob in ${Problems[@]}; do
  for sol in ${Solvers[@]}; do
    echo "Processing problem ${prob} with solver ${sol}"
    # Join all files corresponding to the solvers in a single trace file
    cat ../../../${FILE}.trc/*${prob}.*.${sol}.${sol}.*.trc > ../${prob}.${sol}.trc
    # Remove all lines starting with * and space
    sed -i '/^*/d' ../${prob}.${sol}.trc
    # Remove problem type .gms from problem name
    sed -i "s/${prob}.gms//I" ../${prob}.${sol}.trc
    # Rename the lines to replace the solver with solverproblem, e.g., baron->baronBM
    sed -i "s/${sol}/${sol}${prob}/I" ../${prob}.${sol}.trc
    # Replace HS with HR for it to match logistic
    sed -i 's/HS,/HR,/' ../${prob}.${sol}.trc
    # Replace HC with HRc for it to match logistic
    sed -i 's/HC,/HRc,/' ../${prob}.${sol}.trc
    # Replace BMC with BMc for it to match logistic
    sed -i 's/BMC,/BMc,/' ../${prob}.${sol}.trc
    # Paste trace specifications at the beginning of the file
    cat trc_specs.txt ../${prob}.${sol}.trc > ../${prob}.${sol}.modified
    mv ../${prob}.${sol}.modified ../${prob}.${sol}.trc
  done
done
# Remove all "empty" files with only the header (5 lines)
find ../ -maxdepth 1 -type f -exec awk -v x=5 'NR==x{exit 1}' {} \; -exec rm -f {} \;