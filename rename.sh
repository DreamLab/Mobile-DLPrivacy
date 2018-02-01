#!/bin/bash
export LC_CTYPE=C
NAME="DLRib"
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi
rm -rf Pods/
for i in {1..2}
do
    find . -name "$NAME*" |  sed -e "p;s/$NAME/$1/g" | xargs -n2 mv
done
find . -type f | grep -v "\.git" | xargs sed -i '' "s/$NAME/$1/g"
