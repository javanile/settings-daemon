#!/usr/bin/env sh



sed '$a\[end]' tests/fixtures/test.txt | while read -r line; do
  echo "L: $line"
done

exit

cat tests/fixtures/test.txt /dev/stdin <<EOF
[end]
EOF

echo "L: $line"


done

#cat tests/fixtures/test.txt <(printf "\n%s\n" "[end]")

#sed -i '$a[end]' tests/fixtures/test.txt | while read -r line; do
#  echo "L: $line"
#done
