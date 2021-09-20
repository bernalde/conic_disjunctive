# Script to generate single trace file from separate files out of GAMS
FILE="kclustering"
declare -a Problems=("BM" "HR" "HRc")
declare -a Supersolvers=("sbb")
declare -a Solvers=("knitro" "mosek")
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
        # Add kClus_ to the name of the instances
        sed -i -e 's/random_/kClus_/' ../${prob}.${ssol}${sol}.trc
        # Remove all places where .gms appears
        sed -i 's/.gms//' ../${prob}.${ssol}${sol}.trc
        # Remove problem type from problem name
        sed -i "s/_${prob}_/_/I" ../${prob}.${ssol}${sol}.trc
        # Paste trace specifications at the beginning of the file
        cat trc_specs.txt ../${prob}.${ssol}${sol}.trc > ../${prob}.${ssol}${sol}.modified
        mv ../${prob}.${ssol}${sol}.modified ../${prob}.${ssol}${sol}.trc
    done
  done
done
# Remove all "empty" files with only the header (5 lines)
find ../ -maxdepth 1 -type f -exec awk -v x=5 'NR==x{exit 1}' {} \; -exec rm -f {} \;