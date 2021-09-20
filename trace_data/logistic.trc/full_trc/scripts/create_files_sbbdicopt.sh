# Script to generate single trace file from separate files out of GAMS
FILE="logistic"
declare -a Problems=("BM" "BMc" "HRL" "HRE" "HRc" "HRS")
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
        # Add rename instances to LogReg_
        sed -i -e 's/logistic_/LogReg_/' ../${prob}.${ssol}${sol}.trc
        # Remove all places where .gms appears
        sed -i 's/.gms//' ../${prob}.${ssol}${sol}.trc
        # Remove problem type from problem name
        sed -i "s/_${prob}_/_/I" ../${prob}.${ssol}${sol}.trc
        # Remove all lines with _3_ experiments
        sed -i '/_3_/d' ../${prob}.${ssol}${sol}.trc
        # Remove all lines with _50_ experiments
        sed -i '/_50_/d' ../${prob}.${ssol}${sol}.trc
        # Replace HRS with HR for it to match exp
        sed -i 's/HRS,/HR,/' ../${prob}.${ssol}${sol}.trc
        # Paste trace specifications at the beginning of the file
        cat trc_specs.txt ../${prob}.${ssol}${sol}.trc > ../${prob}.${ssol}${sol}.modified
        mv ../${prob}.${ssol}${sol}.modified ../${prob}.${ssol}${sol}.trc
    done
  done
done

# Remove all "empty" files with only the header (5 lines)
find ../ -maxdepth 1 -type f -exec awk -v x=5 'NR==x{exit 1}' {} \; -exec rm -f {} \;