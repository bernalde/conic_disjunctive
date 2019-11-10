for f in CLay*.gms
do
  # head -n -2 ${f} > temp ; mv temp ${f}
  sed -i 's/^SOLVE LAYOUT_CH USING %RT/*&/' ${f}
  echo "Processing file: $f"
done
