#!/usr/bin/env sh

# docker entrypoint script
server() {
  if [ ! -e "/mdbook/SUMMARY.md" ]; then
    if [ -e "/mdbook/README.md" ]; then
      ln -s /mdbook/README.md /mdbook/SUMMARY.md
    fi
  fi
  /usr/local/bin/mdbook serve -n 0.0.0.0 $PORT
}

if [ "$1" = 'server' ]; then
  server
else
  LOCAL_ARGS=$@
  if [ -z "$LOCAL_ARGS" ]; then
    LOCAL_ARGS="--help"
  fi
  sh -c "/usr/local/bin/mdbook $LOCAL_ARGS"
fi
