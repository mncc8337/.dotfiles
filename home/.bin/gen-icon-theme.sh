# standalone version of change_color.sh found in https://github.com/themix-project/themix-gui/tree/master/plugins/icons_papirus
# Copyright (C) 2026, the Themix Project
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Modified on: 2026-07-26
# Changes made:
#   - Replaced static template copying with dynamic git cloning (--depth 1) 
#     directly from the upstream Papirus repository.
#   - Expanded ICONS_SYMBOLIC_PANEL find command to include 'status', 'apps', 
#     and 'animations' directories.

#!/usr/bin/env bash

set -ueo pipefail
root="$(readlink -f "$(dirname "$0")")"


print_usage() {
    local -i exit_code="$1"

    echo "
usage:
    $0 [-o OUTPUT_THEME_NAME] [-c COLOR] [-d DEST_DIR] PRESET_NAME_OR_PATH

examples:
    $0 -o droid_test_3 -c 5e468c
    $0 monovedek
    $0 -o my-theme-name ./colors/lcars"

    exit "${exit_code:-1}"
}


darker_channel() {
    local value="0x$1"
    local light_delta="0x$2"
    local -i result

    result=$(( value - light_delta ))

    (( result < 0   )) && result=0
    (( result > 255 )) && result=255

    echo "$result"
}


darker() {
    local hexinput="$1"
    local light_delta=${2-10}

    r=$(darker_channel "${hexinput:0:2}" "$light_delta")
    g=$(darker_channel "${hexinput:2:2}" "$light_delta")
    b=$(darker_channel "${hexinput:4:2}" "$light_delta")

    printf '%02x%02x%02x\n' "$r" "$g" "$b"
}


while [[ $# -gt 0 ]]
do
    case "$1" in
        -h|--help)
            print_usage 0
            ;;
        -o|--output)
            OUTPUT_THEME_NAME="$2"
            shift
            ;;
        -d|--destdir)
            output_dir="$2"
            shift
            ;;
        -c|--color)
            ICONS_COLOR="${2#\#}"  # remove leading hash symbol
            shift
            ;;
        -*)
            echo "unknown option $1"
            print_usage 2
            ;;
        *)
            THEME="$1"
            ;;
    esac
    shift
done

if [ -z "${THEME:-}" ]; then
    [ -n "${OUTPUT_THEME_NAME:-}" ] || print_usage 1
    [ -n "${ICONS_COLOR:-}" ] || print_usage 1

    THEME="$OUTPUT_THEME_NAME"
else
    # shellcheck disable=SC1090
    if [ -f "$THEME" ]; then
        source "$THEME"
        THEME=$(basename "$THEME")
    elif [ -f "$root/colors/$THEME" ]; then
        source "$root/colors/$THEME"
    else
        echo "'$THEME' preset not found."
        exit 1
    fi
fi


tmp_dir="$(mktemp -d)"
function post_clean_up {
    rm -rf "$tmp_dir" || true
}
trap post_clean_up EXIT SIGHUP SIGINT SIGTERM


: "${ICONS_COLOR:=$SEL_BG}"
: "${OUTPUT_THEME_NAME:=oomox-$THEME}"

output_dir="${output_dir:-$HOME/.icons/$OUTPUT_THEME_NAME}"

light_folder_fallback="$ICONS_COLOR"
medium_base_fallback="$(darker "$ICONS_COLOR" 20)"
dark_stroke_fallback="$(darker "$ICONS_COLOR" 56)"

: "${ICONS_LIGHT_FOLDER:=$light_folder_fallback}"
: "${ICONS_MEDIUM:=$medium_base_fallback}"
: "${ICONS_DARK:=$dark_stroke_fallback}"
: "${ICONS_SYMBOLIC_ACTION:=${MENU_FG:-}}"
: "${ICONS_SYMBOLIC_PANEL:=${HDR_FG:-}}"


echo ":: Cloning Papirus icon theme from GitHub..."
git clone --depth 1 https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git "$tmp_dir/repo"
theme_base="$tmp_dir/repo/Papirus"
echo "== Template was cloned to $tmp_dir/repo"

#[red]="       #e25252 #bf4b4b #4f1d1d #e4e4e4"
echo ":: Replacing accent colors..."
for size in 22x22 24x24 32x32 48x48 64x64; do
    for icon_path in \
        "$theme_base/$size/places/folder-red"{-*,}.svg \
        "$theme_base/$size/places/user-red"{-*,}.svg
    do
        [ -f "$icon_path" ] || continue  # it's a file
        [ -L "$icon_path" ] && continue  # it's not a symlink

        new_icon_path="${icon_path/-red/-oomox}"
        icon_name="${new_icon_path##*/}"
        symlink_path="${new_icon_path/-oomox/}"  # remove color suffix

        sed -e "s/#e25252/#$ICONS_LIGHT_FOLDER/g" \
            -e "s/#bf4b4b/#$ICONS_MEDIUM/g" \
            -e "s/#4f1d1d/#$ICONS_DARK/g" "$icon_path" > "$new_icon_path"

        ln -sf "$icon_name" "$symlink_path"
    done
done

if [ -n "${ICONS_SYMBOLIC_ACTION:-}" ]; then
    echo ":: Replacing symbolic actions colors..."
    find "$theme_base"/{16x16,22x22,24x24}/actions \
        "$theme_base"/16x16/{devices,places} \
        "$theme_base"/symbolic \
        -type f -name '*.svg' 2>/dev/null \
        -exec sed -i'' -e "s/444444/$ICONS_SYMBOLIC_ACTION/g" '{}' + || true
fi

if [ -n "${ICONS_SYMBOLIC_PANEL:-}" ]; then
    echo ":: Replacing symbolic panel, status, and applet colors..."
    find "$theme_base"/{16x16,22x22,24x24,symbolic}/{status,panel,apps,animations} \
        -type f -name '*.svg' 2>/dev/null \
        -exec sed -i'' -e "s/444444/$ICONS_SYMBOLIC_PANEL/g" -e "s/dfdfdf/$ICONS_SYMBOLIC_PANEL/g" '{}' + || true
fi


echo ":: Exporting theme..."
sed -i'' \
    -e "s/Name=Papirus/Name=$OUTPUT_THEME_NAME/g" \
    "$theme_base/index.theme"

if [ -d "$output_dir" ] ; then
    rm -r "$output_dir"
fi

mkdir -p "$output_dir"
mv "$theme_base"/* "$output_dir/"

echo "== Theme was generated in $output_dir"
