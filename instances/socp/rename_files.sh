rm *HRC*.gms
for f in *BM*.gms
do
  # cp ${FILENAME}'1.gms' ${FILENAME}"$i"'.gms'
  # sed -i '1s/.*/execseed =         '"$i"';/' ${FILENAME}"$i"'.gms'
  cp $f ${f//BM/HRC}
  echo "Creating file: $f"
done
for file in *HRC*.gms
do
  sed -i '190s/.*/$if not set MINLP $set MINLP MINLP/' ${file}
  sed -i '191s/.*/Solve prob_HR2conv using %MINLP% minimizing obj;/' ${file}
  echo "Processing file: $file"
done
