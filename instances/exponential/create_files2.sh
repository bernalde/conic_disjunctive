# From file ${FILENAME}"$K1"'_'"$J1"'_'"$L1"'_'"$REFOR"'_1.gms' generate other files with name
# ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_i.gms' with i from 1 to 10
# Changing seed numer to i, K to disjunctions, J to disjunctive terms and L to variable dimension
FILENAME="random_"
K1="10"
J1="10"
L1="10"
K="2"
J="2"
L="2"
# 'HRL' 'HRLlog'
for REFOR in 'BM' 'BMc' 'BMlog' 'BMlogc' 'HR' 'HRc' 'HRlog' 'HRlogc'
do
  cp ${FILENAME}"$K1"'_'"$J1"'_'"$L1"'_'"$REFOR"'_1.gms' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '2s:.*:set      k               disjunctions                    /1*'"$K"'/ :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '3s:.*:         i               disjunctive terms               /1*'"$J"'/ :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '4s:.*:         j               original variable dimension     /1*'"$L"'/ :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'

  echo ${FILENAME}"$K1"'_'"$J1"'_'"$L1"'_'"$REFOR"'_1.gms'
  echo ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  for i in {2..10}
  do
    cp ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_'"$i"'.gms'
    sed -i '1s/.*/execseed =         '"$i"';/' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_'"$i"'.gms'
    echo "Created file: $i"
  done
done


#for D in ./*; do
#    if [ -d "$D" ]; then
#	if [[ $iter -gt 5 && $iter -lt 12 ]]; then
#	echo $iter
#	sed -i '13s/.*/#PBS -N contracts_'"$iter"'/' parallel.sh
#	sed -i '17s@.*@cd /home/bernalde/IntroToMLProj/GDP_Refomulation_NN/data/Logic_based_B_B_contracts/Euler/'"$iter"'@' parallel.sh
#	fi
#	iter=$(( $iter + 1))
#    fi
#done
