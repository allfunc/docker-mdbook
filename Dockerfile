ARG VERSION=${VERSION:-[VERSION]}

FROM nasqueron/rust-musl-builder AS builder

ARG VERSION

RUN cargo install mdbook --vers ${VERSION} \
  && cargo install mdbook-toc --vers 0.11.0 \
  && cargo install mdbook-mermaid --vers 0.12.6 \
  && cargo install mdbook-plantuml --vers 0.8.0

ENV CARGO_PKG_VERSION=${VERSION}

FROM miy4/plantuml

COPY --from=builder \
  /home/rust/.cargo/bin/mdbook \
  /home/rust/.cargo/bin/mdbook-toc \
  /home/rust/.cargo/bin/mdbook-mermaid \
  /home/rust/.cargo/bin/mdbook-plantuml \
  /usr/local/bin/

# apk
COPY ./install-packages.sh /usr/local/bin/install-packages
RUN apk update && apk add bash bc \
  && INSTALL_VERSION=$VERSION install-packages \
  && rm /usr/local/bin/install-packages

WORKDIR /mdbook
ENV PORT=${PORT:-80}

COPY ./docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["server"]
