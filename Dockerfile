FROM ekidd/rust-musl-builder AS builder

ARG VERSION=${VERSION:-0.3.1}

RUN cargo install mdbook --vers ${VERSION}
RUN cargo install mdbook-toc --vers 0.2.2
RUN cargo install mdbook-mermaid --vers 0.2.2

FROM alpine:latest

COPY --from=builder \
    /home/rust/.cargo/bin/mdbook \
    /usr/local/bin/
COPY --from=builder \
    /home/rust/.cargo/bin/mdbook-toc \
    /usr/local/bin/
COPY --from=builder \
    /home/rust/.cargo/bin/mdbook-mermaid \
    /usr/local/bin/

WORKDIR /mdbook
COPY ./mdbook-demo ./

ENTRYPOINT ["/usr/local/bin/mdbook"]
CMD ["--help"]
