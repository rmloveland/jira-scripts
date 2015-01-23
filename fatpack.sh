for f in $(ls jira*); do
  echo packing $f ...;
  fatpack pack $f > ./out/$f
done

rm -rf ./fatlib/
