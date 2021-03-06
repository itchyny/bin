#!/usr/bin/env bash

vim=/usr/local/bin/vim
if ! [ -e "$vim" ]; then
  vim=/usr/bin/vim
fi

if [ -t 0 ]; then
  exec $vim "$@" < /dev/tty
elif [ -t 1 ]; then
  f=$(mktemp -t vim)
  cat /dev/stdin > "$f"
  $vim "$f" < /dev/tty
  exit_code=$?
  rm -f "$f" || :
  exit $exit_code
else
  exec $vim "$@"
fi
