# From file ${FILENAME}"$K1"'_'"$J1"'_'"$L1"'_'"$REFOR"'_1.gms' generate other files with name
# ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_i.gms' with i from 1 to 10
# Changing seed numer to i, K to disjunctions, J to disjunctive terms and L to variable dimension
FILENAME="logistic_"
K1="2"
J1="20"
L1="1"
K="10"
J="20"
L="2"
for REFOR in 'BM' 'BMc' 'HRS' 'HRc' 'HRE' 'HRL'
do
  cp ${FILENAME}"$K1"'_'"$J1"'_'"$L1"'_'"$REFOR"'_1.gms' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '2s:.*:set      d               dimensions                    /1*'"$K"'/ :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '3s:.*:         n               data points                   /1*'"$J"'/ :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  sed -i '5s:.*:scalar sigma standard deviation /'"$L"'/; :' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'

  echo ${FILENAME}"$K1"'_'"$J1"'_'"$L1"'_'"$REFOR"'_1.gms'
  echo ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms'
  for i in {2..10}
  do
    cp ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_1.gms' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_'"$i"'.gms'
    sed -i '1s/.*/execseed =         '"$i"';/' ${FILENAME}"$K"'_'"$J"'_'"$L"'_'"$REFOR"'_'"$i"'.gms'
    echo "Created file: $i"
  done
done
