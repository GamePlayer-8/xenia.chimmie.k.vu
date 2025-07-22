#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

cd "$SCRIPT_PATH"

rm -f art/bin/*.minimal.png

echo 'Executing setup...'
sh index.sh
sh res/scripts/set.sh res/parser.conf index.html
sh res/scripts/set.sh res/parser.conf README.md

cp res/img/icon.png .
cp res/img/icon.ico .
cp icon.png favicon.png
cp icon.ico favicon.ico

apk add --no-cache sed

sed -i 's/index.html//g' .gitignore
sed -i 's/*.minimal.png//g' .gitignore
