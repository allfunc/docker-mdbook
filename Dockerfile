ARG VERSION=${VERSION:-[VERSION]}

FROM allfunc/rust-musl-crate AS builder

ARG VERSION

COPY ./docker/mybook /home/rust/src/

# The builder image writes [build] target = <musl triple> into
# $CARGO_HOME/config.toml, which `cargo install` (run by cargo-run-bin) reads.
RUN cargo bin --install

FROM plantuml/plantuml

ARG RUST_VER=1.99.0

# the base image runs as appuser; keep root for setup and runtime
USER root

COPY --from=builder \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook/0.5.4/bin/mdbook \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-toc/0.15.4/bin/mdbook-toc \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-mermaid/0.17.1/bin/mdbook-mermaid \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-plantuml/2.0.0/bin/mdbook-plantuml \
  /usr/local/bin/

# init packages 
# apk
COPY ./install-packages.sh /usr/local/bin/install-packages
RUN INSTALL_VERSION=$VERSION install-packages \
  && rm /usr/local/bin/install-packages

# init workdir
WORKDIR /mdbook
COPY ./mdbook-demo /mdbook
ENV PORT=80 \
  HOME=/mdbook

COPY ./docker/do-touch /usr/local/sbin/
COPY ./docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["server"]
