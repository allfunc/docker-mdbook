ARG VERSION=${VERSION:-[VERSION]}

FROM allfunc/rust-musl-crate AS builder

ARG VERSION
RUN cargo install cargo-local-install --no-default-features
RUN cargo local-install --locked mdbook@${VERSION} --root .local
RUN cargo local-install --unlocked mdbook-plantuml@0.8.0 --root .local
RUN cargo local-install --unlocked mdbook-toc@0.14.1 --root .local
RUN cargo local-install --unlocked mdbook-mermaid@0.12.6 --root .local

RUN cp -L /home/rust/src/.local/bin/* /home/rust/.cargo/bin

FROM miy4/plantuml

COPY --from=builder \
  /home/rust/.cargo/bin/mdbook \
  /home/rust/.cargo/bin/mdbook-plantuml \
  /home/rust/.cargo/bin/mdbook-toc \
  /home/rust/.cargo/bin/mdbook-mermaid \
  /usr/local/bin/

# apk
COPY ./install-packages.sh /usr/local/bin/install-packages
RUN apk update && apk add bash bc \
  && INSTALL_VERSION=$VERSION install-packages \
  && rm /usr/local/bin/install-packages

# init workdir
WORKDIR /mdbook
COPY ./mdbook-demo /mdbook
ENV PORT=${PORT:-80} \
  HOME=/mdbook

COPY ./docker/do-touch /usr/local/bin/
COPY ./docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["server"]
