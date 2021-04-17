# File to create instances copying the instalce FILENAME with
# seed number 1 into files of the same name with different seed
FILENAME="random_10_10_10_BM_"
echo ${FILENAME}
for i in {2..10}
do
  cp ${FILENAME}'1.gms' ${FILENAME}"$i"'.gms'
  sed -i '1s/.*/execseed =         '"$i"';/' ${FILENAME}"$i"'.gms'
  echo "Created file: $i"
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
