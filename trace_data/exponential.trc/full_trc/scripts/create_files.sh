# Script to generate single trace file from separate files out of GAMS
FILE="exponential"
declare -a Problems=("BM" "BMc" "BMlog" "BMlogc" "HR" "HRc" "HRL" "HRLlog" "HRlog" "HRlogc")
declare -a Solvers=("baron" "antigone" "mosek" "knitro" "scip")
for prob in ${Problems[@]}; do
  for sol in ${Solvers[@]}; do
    echo "Processing problem ${prob} with solver ${sol}"
    # Join all files corresponding to the solvers in a single trace file
    cat ../../../${FILE}.trc/*${prob}_*.${sol}.${sol}.*.trc > ../${prob}.${sol}.trc
    # Remove all lines starting with * and space
    sed -i '/^*/d' ../${prob}.${sol}.trc
    # Rename the lines to replace the solver with solverproblem, e.g., baron->baronBM
    sed -i "s/${sol}/${sol}${prob}/I" ../${prob}.${sol}.trc
    # Add exp_ to the name of the instances
    sed -i -e 's/^/exp_/' ../${prob}.${sol}.trc
    # Remove all places where .gms appears
    sed -i 's/.gms//' ../${prob}.${sol}.trc
    # Remove problem type from problem name
    sed -i "s/_${prob}_/_/I" ../${prob}.${sol}.trc
    # Replace HRlog with HR for it to match logistic
    sed -i 's/HRlog,/HR,/' ../${prob}.${sol}.trc
    # Replace BMlog with BM for it to match logistic
    sed -i 's/BMlog,/BM,/' ../${prob}.${sol}.trc
    # Replace HRlogc with HRc for it to match logistic
    sed -i 's/HRlogc,/HRc,/' ../${prob}.${sol}.trc
    # Replace BMlogc with BMc for it to match logistic
    sed -i 's/BMlogc,/BMc,/' ../${prob}.${sol}.trc
    # Paste trace specifications at the beginning of the file
    cat trc_specs.txt ../${prob}.${sol}.trc > ../${prob}.${sol}.modified
    mv ../${prob}.${sol}.modified ../${prob}.${sol}.trc
  done
done
# Remove all "empty" files with only the header (5 lines)
find ../ -maxdepth 1 -type f -exec awk -v x=5 'NR==x{exit 1}' {} \; -exec rm -f {} \;