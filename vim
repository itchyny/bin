#!/usr/bin/env bash

vim=/usr/local/bin/vim
if ! [ -e "$vim" ]; then
  vim=/usr/bin/vim
fi

if [ -t 0 ]; then
  $vim "$@" < /dev/tty
  exit_code=$?
else
  f=$(mktemp -t vim)
  cat /dev/stdin > "$f"
  $vim "$f" < /dev/tty
  exit_code=$?
  rm -f "$f" || :
fi

exit $exit_code
