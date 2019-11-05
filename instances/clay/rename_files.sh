for f in CLay*.gms
do
  # head -n -2 ${f} > temp ; mv temp ${f}
  sed -i 's/^LAYOUT_CH/*&/' ${f}
  echo "Processing file: $f"
done
