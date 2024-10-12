ARG VERSION=${VERSION:-[VERSION]}

FROM allfunc/rust-musl-crate AS builder

ARG VERSION

RUN echo 'TARGETPLATFORM: '${TARGETPLATFORM}' PlATFORM: '$(uname -m)

COPY ./docker/mybook /home/rust/src/
RUN cargo bin --install

FROM plantuml/plantuml

ARG RUST_VER=1.81.0

COPY --from=builder \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook/0.4.40/bin/mdbook \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-plantuml/0.8.0/bin/mdbook-plantuml \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-toc/0.14.2/bin/mdbook-toc \
  /home/rust/src/.bin/rust-${RUST_VER}/mdbook-mermaid/0.14.0/bin/mdbook-mermaid \
  /usr/local/bin/

# init workdir
WORKDIR /mdbook
COPY ./mdbook-demo /mdbook
ENV PORT=80 \
  HOME=/mdbook

COPY ./docker/do-touch /usr/local/bin/
COPY ./docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["server"]
