#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
DATA_PATH="${DATA_PATH:-$SCRIPT_PATH/../art}"
TMP_PATH="${TMP_PATH:-/tmp}"
OUT_FILE="${OUT_FILE:-$TMP_PATH/files.html}"
export SHARED_SORTER="${SHARED_SORTER:-$TMP_PATH/sort.conf.tmp}"

cd "$SCRIPT_PATH"

rm -f "$OUT_FILE"
rm -f "$SHARED_SORTER"

# Install ImageMagick
apk add --no-cache imagemagick >/dev/null

echo '<div class="files">' > "$OUT_FILE"

for file_path in $(find "$DATA_PATH/bin" -maxdepth 1 -type f); do
	echo 'Parsing ART file "'"$(basename "$file_path")"'"...'
	export OUT_PATH="$TMP_PATH"
	export SRC_PATH="$DATA_PATH/bin"
	export ERASE_PATH="$SCRIPT_PATH/../"
	export TARGET="$(basename "$file_path")"
	sh "$SCRIPT_PATH/celement.sh"
#	cat "$TMP_PATH/${TARGET}.c.html" >> "$OUT_FILE"
done

sort -rn "$SHARED_SORTER" > "$TMP_PATH/sorted.tmp"

for line in $(cat "$TMP_PATH/sorted.tmp"); do
	file_name="$(echo "$line" | cut -f 2 -d '|')"
	cat "$TMP_PATH/${file_name}.png.c.html" >> "$OUT_FILE"
done

echo '</div>' >> "$OUT_FILE"
