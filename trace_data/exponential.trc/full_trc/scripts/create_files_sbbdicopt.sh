# Script to generate single trace file from separate files out of GAMS
FILE="exponential"
declare -a Problems=("BM" "BMc" "BMlog" "BMlogc" "HR" "HRc" "HRL" "HRLlog" "HRlog" "HRlogc")
declare -a Supersolvers=("sbb" "dicopt2")
declare -a Solvers=("conopt" "ipopth" "knitro" "mosek")
for prob in ${Problems[@]}; do
  for ssol in ${Supersolvers[@]}; do
    for sol in ${Solvers[@]}; do
        echo "Processing problem ${prob} with solver ${ssol}.${sol}"
        # Join all files corresponding to the solvers in a single trace file
        cat ../../../${FILE}.trc/*${prob}_*.${ssol}.${sol}.*.trc > ../${prob}.${ssol}${sol}.trc
        # Remove all lines starting with * and space
        sed -i '/^*/d' ../${prob}.${ssol}${sol}.trc
        # Rename the lines to replace the solver with solverproblem, e.g., baron->baronBM
        sed -i "s/${ssol}/${ssol}${sol}${prob}/I" ../${prob}.${ssol}${sol}.trc
        # Add exp_ to the name of the instances
        sed -i -e 's/^/exp_/' ../${prob}.${ssol}${sol}.trc
        # Remove all places where .gms appears
        sed -i 's/.gms//' ../${prob}.${ssol}${sol}.trc
        # Remove problem type from problem name
        sed -i "s/_${prob}_/_/I" ../${prob}.${ssol}${sol}.trc
        # Replace HRlog with HR for it to match logistic
        sed -i 's/HRlog,/HR,/' ../${prob}.${ssol}${sol}.trc
        # Replace BMlog with BM for it to match logistic
        sed -i 's/BMlog,/BM,/' ../${prob}.${ssol}${sol}.trc
        # Replace HRlogc with HRc for it to match logistic
        sed -i 's/HRlogc,/HRc,/' ../${prob}.${ssol}${sol}.trc
        # Replace BMlogc with BMc for it to match logistic
        sed -i 's/BMlogc,/BMc,/' ../${prob}.${ssol}${sol}.trc
        # Paste trace specifications at the beginning of the file
        cat trc_specs.txt ../${prob}.${ssol}${sol}.trc > ../${prob}.${ssol}${sol}.modified
        mv ../${prob}.${ssol}${sol}.modified ../${prob}.${ssol}${sol}.trc
    done
  done
done
# Remove all "empty" files with only the header (5 lines)
find ../ -maxdepth 1 -type f -exec awk -v x=5 'NR==x{exit 1}' {} \; -exec rm -f {} \;