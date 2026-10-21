[![CircleCI](https://circleci.com/gh/allfunc/docker-mdbook/tree/main.svg?style=svg)](https://circleci.com/gh/allfunc/docker-mdbook/tree/main)
[![Docker Pulls](https://img.shields.io/docker/pulls/allfunc/mdbook.svg)](https://hub.docker.com/r/allfunc/mdbook)

# `docker-mdbook` (Alpine)

> A set of tool for mdbook.

| Package          | Version |
| ---------------- | ------- |
| mdbook           | 0.5.4   |
| mdbook-toc       | 0.15.4  |
| mdbook-mermaid   | 0.17.1  |
| mermaid (NPM/JS) | 11.12.0 |
| mdbook-plantuml  | 2.0.0   |
| Rust (builder)   | 1.99.0  |

## Upgrade

Bump all of these together — a missed file ships a stale image tag.

| File                       | What to change                                                                                          |
| -------------------------- | ------------------------------------------------------------------------------------------------------- |
| `docker/mybook/Cargo.toml` | version pins in `[package.metadata.bin]` **and** `[dependencies]`                                       |
| `docker/mybook/Cargo.lock` | regenerate with `cargo update` (below)                                                                  |
| `Dockerfile`               | builder image tag, `ARG RUST_VER`, and the four `.bin/rust-${RUST_VER}/<crate>/<version>/bin/...` paths |
| `README.md`                | the version table above                                                                                 |
| `.env.build`               | `VERSION=` — drives the Docker tag, the CircleCI matrix and the test build arg                          |
| `.circleci/config.yml`     | `docker-tag:` under `base-matrix`                                                                       |

### `cargo update`

`docker/mybook` is a dummy crate whose only job is to pin the mdBook binaries.
`cargo-run-bin` installs from `[package.metadata.bin]` (the `RUN cargo bin --install`
step in the `Dockerfile`), and `mdbook` is `locked = true`, so the committed
`Cargo.lock` decides which version gets installed.

```sh
cd docker/mybook

# 1. edit [package.metadata.bin] and [dependencies] in Cargo.toml to the new versions
#    (e.g. mdbook = "0.5.4"), then

# 2. refresh the lockfile
cargo update

# 3. check what got resolved
grep -A1 '^name = "mdbook' Cargo.lock
```

`cargo update` on its own only moves versions inside the semver ranges already in
`Cargo.toml` — edit `Cargo.toml` first when jumping minor/major.

To generate the lockfile with the same toolchain the build uses:

```sh
docker run --rm -v "$PWD/docker/mybook:/home/rust/src" -w /home/rust/src \
  allfunc/rust-musl-crate:1.88.0 cargo update
```

Then build and smoke-test:

```sh
./compile.sh b
docker run --rm allfunc/mdbook -V
```

## `GIT`

- https://github.com/allfunc/docker-mdbook

## `Docker hub`

- Docker Image: allfunc/mdbook
- https://hub.docker.com/r/allfunc/mdbook

## Usage

1. create SUMMARY.md file with such content.

```markdown
# Summary

- [Chapter 1](./chapter_1.md)
```

2. Copy bin/preview.sh to same folder.
   - or download https://raw.githubusercontent.com/allfunc/docker-mdbook/main/bin/preview.sh
   - chmod +x preview.sh
3. Run following command

```
./preview.sh start
```

### Curl Example

```
curl https://raw.githubusercontent.com/allfunc/docker-mdbook/main/bin/preview.sh | bash -s -- start

or

curl -L https://bit.ly/exec-mdbook | bash -s -- start
```

### import HTML

- create any folder (such as public) inside src folder

```
<div data-import="/public/import-demo.html"></div>
```

- sample md file
  - https://raw.githubusercontent.com/allfunc/docker-mdbook/main/mdbook-demo/src/importDemo_2.md
- sample public folder (could be any)
  - https://github.com/allfunc/docker-mdbook/tree/main/mdbook-demo/src/public
- sample import HTML file
  - https://github.com/allfunc/docker-mdbook/blob/main/mdbook-demo/src/public/import-demo.html

## APP

### mdbook

- https://github.com/rust-lang/mdBook
- https://crates.io/crates/mdbook
- DOC http://rust-lang-nursery.github.io/mdBook/index.html

### mdbook-toc

- https://github.com/badboy/mdbook-toc
- https://crates.io/crates/mdbook-toc

### mdbook-mermaid

- https://github.com/badboy/mdbook-mermaid
- https://crates.io/crates/mdbook-mermaid
- https://cdn.jsdelivr.net/npm/mermaid@latest/dist/

### mdbook-plantuml

- https://github.com/sytsereitsma/mdbook-plantuml
- https://crates.io/crates/mdbook-plantuml
- https://plantuml.com/
- https://the-lum.github.io/puml-themes-gallery/diagrams/index.html

### mdbook-pandoc (disabled)

Pandoc is not installed in this image — see the commented `apt-get` line in
`install-packages.sh` — so `mdbook-pandoc` is not bundled. The commented
`[output.pandoc.profile.pptx]` block in `mdbook-demo/book.toml` is kept for reference.

If you enable it yourself, the pptx output sits at:

- docker cp mdbook:/mdbook/book/pandoc/pptx/output.pptx .

### update docker image

```
docker pull allfunc/mdbook
```

## Troubleshooting

```
docker run --rm allfunc/mdbook -V
```

```
docker run -p 3888:3888 -e PORT=3888 \
    -u $(id -u):$(id -g) \
    -v $(pwd):/mdbook/src \
    --name mdbook \
    --rm allfunc/mdbook
```

## Official Doc

- SUMMARY.md
  - https://rust-lang.github.io/mdBook/format/summary.html
- Render
  - https://rust-lang.github.io/mdBook/format/configuration/renderers.html

MIT 2026
