#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
TARGET="${TARGET:-xenia_drawing0.png}"
ERASE_PATH="${ERASE_PATH:-$SCRIPT_PATH}"
SRC_PATH="${SRC_PATH:-$SCRIPT_PATH/../art/bin}"
OUT_PATH="${OUT_PATH:-/tmp}"
SHARED_SORTER="${SHARED_SORTER:-$OUT_PATH/sort.conf.tmp}"

TARGET="${TARGET%.*}"

if ! [ -f "$SRC_PATH/${TARGET}.png" ]; then
	echo 'File not found!'
	exit 1
fi

cd "$SRC_PATH"

rm -f "$OUT_PATH/${TARGET}.png.c.html"
rm -f "$OUT_PATH/${TARGET}.png.c.conf"

echo '<div class="filedoc" id="%FILENAME%">' > "$OUT_PATH/${TARGET}.png.c.html"
cat "$SCRIPT_PATH/element.html" >> "$OUT_PATH/${TARGET}.png.c.html"

# Fix size for faster page rendering
convert "${SRC_PATH}/${TARGET}.png" -resize 420 "${SRC_PATH}/${TARGET}.minimal.jpg"

echo '%FILESRC%='"${SRC_PATH/$ERASE_PATH/}/${TARGET}.png" > "$OUT_PATH/${TARGET}.png.c.conf"
echo '%PREVSRC%='"${SRC_PATH/$ERASE_PATH/}/${TARGET}.minimal.jpg" >> "$OUT_PATH/${TARGET}.png.c.conf"
echo '%FILENAME%='"${TARGET}" >> "$OUT_PATH/${TARGET}.png.c.conf"

if [ -f "$SRC_PATH/../svg/${TARGET}.svg" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../svg/${TARGET}.svg"'"><img src="res/img/svg.svg" alt=":svg_download:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"
fi

if [ -f "$SRC_PATH/../gimp/${TARGET}.xcf" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../gimp/${TARGET}.xcf"'"><img src="res/img/gimp.svg" alt=":xcf_download:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"
fi

if [ -f "$SRC_PATH/../license/${TARGET}.txt" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../license/${TARGET}.txt"'"><img src="res/img/license.svg" alt=":license:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"
fi

if [ -f "$SRC_PATH/../links/${TARGET}.conf" ]; then
	for conf_line in $(cat "$SRC_PATH/../links/${TARGET}.conf"); do
		echo '<a href="'"$(echo "$conf_line" | cut -d '|' -f 2)"'"><img src="res/img/'"$(echo "$conf_line" | cut -d '|' -f 1)"'.svg" alt=":'"$(echo "$conf_line" | cut -d '|' -f 1)"':" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"
	done
fi

echo '<a href="#%FILENAME%"><img src="res/img/link.svg" alt=":symlink:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"

echo '</div></div><hr/>' >> "$OUT_PATH/${TARGET}.png.c.html"

echo 'Configuring "'"${TARGET}.png.c.html"'"...'

sh "$SCRIPT_PATH/scripts/set.sh" "$OUT_PATH/${TARGET}.png.c.conf" "$OUT_PATH/${TARGET}.png.c.html"

if [ -f "$SRC_PATH/../desc/${TARGET}.md" ]; then
	sed -i -e '/%DESCRIPTION%/e markdown '"$SRC_PATH/../desc/${TARGET}.md" "$OUT_PATH/${TARGET}.png.c.html"
	sed -i 's/%DESCRIPTION%//g' "$OUT_PATH/${TARGET}.png.c.html"
	sort_time="$(cat "$SRC_PATH/../desc/${TARGET}.md" | head -n 1 | cut -d ' ' -f 2-)"
	unix_time="$(date -d "$sort_time" +%s 2>/dev/null)"
	unix_time="${unix_time:-0}"
	echo "$unix_time"'|'"${TARGET}" >> "$SHARED_SORTER"
else
	sed -i 's/%DESCRIPTION%/No description provided./g' "$OUT_PATH/${TARGET}.png.c.html"
	echo '0|'"${TARGET}" >> "$SHARED_SORTER"
fi
