ARG VERSION=${VERSION:-[VERSION]}

FROM allfunc/rust-musl-crate AS builder

ARG VERSION

RUN echo 'TARGETPLATFORM: '${TARGETPLATFORM}' PlATFORM: '$(uname -m)

COPY ./docker/mybook /home/rust/src/
RUN cargo bin --install

FROM miy4/plantuml

COPY --from=builder \
  /home/rust/src/.bin/rust-1.73.0/mdbook/0.4.35/bin/mdbook \
  /home/rust/src/.bin/rust-1.73.0/mdbook-plantuml/0.8.0/bin/mdbook-plantuml \
  /home/rust/src/.bin/rust-1.73.0/mdbook-toc/0.14.1/bin/mdbook-toc \
  /home/rust/src/.bin/rust-1.73.0/mdbook-mermaid/0.12.6/bin/mdbook-mermaid \
  /usr/local/bin/

# apk
# COPY ./install-packages.sh /usr/local/bin/install-packages
# RUN apk update && apk add bash bc \
#   && INSTALL_VERSION=$VERSION install-packages \
#   && rm /usr/local/bin/install-packages

# init workdir
WORKDIR /mdbook
COPY ./mdbook-demo /mdbook
ENV PORT=${PORT:-80} \
  HOME=/mdbook

COPY ./docker/do-touch /usr/local/bin/
COPY ./docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["server"]
