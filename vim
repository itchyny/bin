#!/bin/bash

vim=/opt/homebrew/bin/vim
if ! [ -x "$vim" ]; then
  vim=/usr/local/bin/vim
  if ! [ -x "$vim" ]; then
    vim=/usr/bin/vim
  fi
fi

if [ -t 0 ]; then
  exec $vim "$@" < /dev/tty
elif [ -t 1 ]; then
  f=$(mktemp)
  cat /dev/stdin > "$f"
  $vim "$f" < /dev/tty
  exit_code=$?
  rm -f "$f" || :
  exit $exit_code
else
  exec $vim "$@"
fi
