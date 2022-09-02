ARG VERSION=${VERSION:-[VERSION]}

FROM ekidd/rust-musl-builder AS builder

ARG VERSION

RUN cargo install mdbook --vers ${VERSION}; \
    cargo install mdbook-toc --vers 0.9.0; \
    cargo install mdbook-mermaid --vers 0.11.2; \
    cargo install mdbook-presentation-preprocessor --vers 0.2.2; \
    cargo install mdbook-plantuml --vers 0.8.0

FROM miy4/plantuml

COPY --from=builder \
    /home/rust/.cargo/bin/mdbook \
    /usr/local/bin/
COPY --from=builder \
    /home/rust/.cargo/bin/mdbook-toc \
    /usr/local/bin/
COPY --from=builder \
    /home/rust/.cargo/bin/mdbook-mermaid \
    /usr/local/bin/
COPY --from=builder \
    /home/rust/.cargo/bin/mdbook-presentation-preprocessor \
    /usr/local/bin/
COPY --from=builder \
    /home/rust/.cargo/bin/mdbook-plantuml \
    /usr/local/bin/

RUN (rm /tmp/* 2>/dev/null || true) \
    && (rm -rf /var/cache/apk/* 2>/dev/null || true)

WORKDIR /mdbook
COPY ./mdbook-demo ./

ENTRYPOINT ["/usr/local/bin/mdbook"]
CMD ["--help"]
