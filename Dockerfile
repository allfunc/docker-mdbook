FROM ekidd/rust-musl-builder AS builder

RUN cargo install mdbook --vers 0.2.1

FROM alpine:latest

COPY --from=builder \
    /home/rust/.cargo/bin/mdbook \
    /usr/local/bin/

ENV BOOKDIR /mdbook

WORKDIR $BOOKDIR

ENTRYPOINT ["/usr/local/bin/mdbook"]
CMD ["--help"]
