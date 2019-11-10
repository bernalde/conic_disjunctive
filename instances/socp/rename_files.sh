rm *HRc*.gms
for f in *BM*.gms
do
  # cp ${FILENAME}'1.gms' ${FILENAME}"$i"'.gms'
  # sed -i '1s/.*/execseed =         '"$i"';/' ${FILENAME}"$i"'.gms'
  cp $f ${f//BM/HRc}
  echo "Creating file: $f"
done
for file in *HRc*.gms
do
  sed -i '190s/.*/$if not set TYPE $set TYPE MIQCP/' ${file}
  sed -i '191s/.*/Solve prob_HR2c using %TYPE% minimizing obj;/' ${file}
  echo "Processing file: $file"
done
