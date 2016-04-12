#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi
rm -rf Pods/
for i in {1..2}
do
    find . -name 'Backbone*' -print0 | xargs -0 rename -S 'Backbone' "$1"
done
ack --literal --files-with-matches 'Backbone' | xargs sed -i '' "s/Backbone/$1/g"
