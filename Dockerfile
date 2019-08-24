FROM ekidd/rust-musl-builder AS builder

ARG VERSION=${VERSION:-0.3.1}

RUN cargo install mdbook --vers ${VERSION} 

FROM alpine:latest

COPY --from=builder \
    /home/rust/.cargo/bin/mdbook \
    /usr/local/bin/

WORKDIR /mdbook

ENTRYPOINT ["/usr/local/bin/mdbook"]
CMD ["--help"]
