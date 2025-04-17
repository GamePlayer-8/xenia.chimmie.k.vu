#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

cd "$SCRIPT_PATH"

echo '<!DOCTYPE html>' > index.html
echo '<html lang="en-US">' >> index.html
cat res/head.html >> index.html

echo '<body>' >> index.html
cat res/source.html >> index.html
echo '<a hidden="true" rel="me" href="https://catcatnya.com/@gameplayervent">Mastodon</a>' >> index.html
echo '<a hidden="true" rel="me" href="https://mrrp.chimmie.k.vu/@gameplayer">Mrrp instance</a>' >> index.html
echo '<a hidden="true" rel="me" href="https://mrrp.chimmie.k.vu/@art">Mrrp instance - Art Account</a>' >> index.html
echo '<div class="maindiv">' >> index.html
echo '<div class="main">' >> index.html
markdown INDEX.md >> index.html
export TMP_PATH="/tmp"
export OUT_FILE="/tmp/files.html"
sh "$SCRIPT_PATH/res/build_c.sh"
cat "$OUT_FILE" >> index.html
echo '</div>' >> index.html
echo '</div>' >> index.html
cat res/credits.html >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html
