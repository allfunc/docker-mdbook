ARG VERSION=${VERSION:-[VERSION]}

FROM allfunc/rust-musl-crate AS builder

ARG VERSION

COPY ./docker/mybook /home/rust/src/
RUN cargo bin --install

FROM plantuml/plantuml

ARG RUST_VER=1.89.0

COPY --from=builder \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook/0.4.52/bin/mdbook \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-plantuml/0.8.0/bin/mdbook-plantuml \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-toc/0.14.2/bin/mdbook-toc \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-mermaid/0.15.0/bin/mdbook-mermaid \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-pandoc/0.10.5/bin/mdbook-pandoc \
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
