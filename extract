#!/bin/bash
# shellcheck disable=SC2012
set -euo pipefail

cmdname="$(basename "${BASH_SOURCE[0]}")"

if [[ $# -ne 1 ]]; then
  echo "$cmdname: specify target file" > /dev/stderr
  exit 1
fi

target="$1"
target_abspath="$(realpath "$target")"
name="$(basename "$target")"

if [[ "$(file --brief --mime-type "$target" || :)" == "text"* ]]; then
  echo "$cmdname: $target is a text file" > /dev/stderr
  exit 1
fi

while :; do
  dir="$(dirname "$target_abspath")/$name.$RANDOM"
  [[ -e "$dir" ]] || break
done
mkdir "$dir"
exit_traps=""
add_exit_trap() {
  exit_traps="$(printf "%q " "$@"); $exit_traps"
}
trap '/bin/bash -c "$exit_traps"' EXIT
add_exit_trap rm -rf "$dir"

mv "$target_abspath" "$dir/$name"
mv_if_exists() {
  if [[ -e "$1" ]]; then
    mv "$1" "$2"
  fi
}
export -f mv_if_exists
add_exit_trap mv_if_exists "$dir/$name" "$target_abspath"

suffix=""

pushd "$dir" >/dev/null 2>&1
case "$name" in
  *.tar.gz) tar xvf "$name"  ; suffix=".tar.gz" ;;
  *.tgz) tar xvf "$name"     ; suffix=".tgz"    ;;
  *.tar.bz2) tar xjvf "$name"; suffix=".tar.bz2";;
  *.tbz) tar xjvf "$name"    ; suffix=".tbz"    ;;
  *.tar.xz) tar xJvf "$name" ; suffix=".tar.xz" ;;
  *.tar.Z) tar xvf "$name"   ; suffix=".tar.Z"  ;;
  *.tar) tar xvf "$name"     ; suffix=".tar"    ;;
  *.zip)
    if command -v ditto >/dev/null; then
      ditto -V -x -k --sequesterRsrc "$name" .
    else
      unzip "$name"
    fi                       ; suffix=".zip"    ;;
  *.lzh) lha e "$name"       ; suffix=".lzh"    ;;
  *.gz) gzip -d "$name"      ; suffix=".gz"     ;;
  *.bz2) bzip2 -dc "$name"   ; suffix=".bz2"    ;;
  *.Z) uncompress "$name"    ; suffix=".Z"      ;;
  *.arj) unarj "$name"       ; suffix=".arj"    ;;
  *) echo "$cmdname: not an archive: $target" >&2; exit 1;;
esac
mv_if_exists "$dir/$name" "$(dirname "$target_abspath")"
popd >/dev/null 2>&1

shopt -s dotglob
if [[ "$(ls -d1 "$dir/"* | wc -l)" -eq 1 ]] && \
  [[ "$(basename "$(ls -d1 "$dir/"*)")" == "$(basename "$name" "$suffix")" ]]; then
  path="$(ls -d1 "$dir/"*)"
  new_path="./$(basename "$path")"
  i=0
  prefix="$new_path"
  while [[ -e "$new_path" ]]; do
    i="$((i + 1))"
    new_path="${prefix}_$i"
  done
  mv "$path" "$new_path"
  echo "output: $new_path" >&2
else
  new_path="$(basename "$target_abspath" "$suffix")"
  i=0
  prefix="$new_path"
  while [[ -e "$new_path" ]]; do
    i="$((i + 1))"
    new_path="${prefix}_$i"
  done
  mkdir "$new_path"
  mv "$dir/"* "$new_path"
  echo "output: $new_path" >&2
fi
