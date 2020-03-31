FILENAME="random_"
K1="10"
J1="10"
L1="10"
K="5"
J="10"
L="10"
for REFOR in 'BMc' 'BMlog' 'BMlogc' 'HR' 'HRc' 'HRlog' 'HRlogc' 'HRL' 'HRLlog'
do
  cp ${FILENAME}"$K1"'_'"$J1"'_'"$L1"'_'"$REFOR"'_1.gms' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '2s:.*:set      k               disjunctions                    /1*'"$K"'/ :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '3s:.*:         i               disjunctive terms               /1*'"$J"'/ :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '4s:.*:         j               disjunctive terms               /1*'"$L"'/ :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'

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
