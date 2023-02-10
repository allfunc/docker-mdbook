#!/usr/bin/env sh

# docker entrypoint script
server() {
  MDBOOK_SRC="/mdbook/src"
  if [ ! -e "${MDBOOK_SRC}/SUMMARY.md" ]; then
    if [ ! -e "${MDBOOK_SRC}/README.md" ]; then
      cat > ${MDBOOK_SRC}/README.md << EOF
# Summary

- [Chapter 1](./chapter_1.md)
EOF
      cd ${MDBOOK_SRC}
      ln -s ./README.md ./SUMMARY.md
      cd -
    fi
  fi
  /usr/local/bin/mdbook serve -n 0.0.0.0 -p $PORT
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
