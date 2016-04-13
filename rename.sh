#!/bin/bash
export LC_CTYPE=C
NAME="Backbone"
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi
rm -rf Pods/
for i in {1..2}
do
    find . -name "$NAME*" -print0 | xargs -0 rename -S "$NAME" "$1"
done
#export LC_CTYPE=C
find . -type f | xargs sed -i '' "s/$NAME/$1/g"