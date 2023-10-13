ARG VERSION=${VERSION:-[VERSION]}

FROM allfunc/rust-musl-crate AS builder

ARG VERSION

RUN cargo install mdbook --vers ${VERSION} \
  && cargo install mdbook-plantuml --vers 0.8.0 \
  && cargo install mdbook-toc --vers 0.11.2 \
  && cargo install mdbook-mermaid --vers 0.12.6

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
