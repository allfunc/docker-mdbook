[![CircleCI](https://circleci.com/gh/allfunc/docker-mdbook/tree/main.svg?style=svg)](https://circleci.com/gh/allfunc/docker-mdbook/tree/main)
[![Docker Pulls](https://img.shields.io/docker/pulls/allfunc/mdbook.svg)](https://hub.docker.com/r/allfunc/mdbook)

# `docker-mdbook` (Alpine)

> A set of tool for mdbook.

| Package         | Version |
| --------------- | ------- |
| mdbook          | 0.4.52  |
| mdbook-toc      | 0.14.2  |
| mdbook-mermaid  | 0.15.0  |
| mdbook-plantuml | 0.8.0   |
| mdbook-pandoc   | 0.10.5  |

## `GIT`

-   https://github.com/allfunc/docker-mdbook

## `Docker hub`

-   Docker Image: allfunc/mdbook
-   https://hub.docker.com/r/allfunc/mdbook

## Usage

1. create SUMMARY.md file with such content.

```markdown
# Summary

-   [Chapter 1](./chapter_1.md)
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

-   create any folder (such as public) inside src folder

```
<div data-import="/public/import-demo.html"></div>
```

-   sample md file
    -   https://raw.githubusercontent.com/allfunc/docker-mdbook/main/mdbook-demo/src/importDemo_2.md
-   sample public folder (could be any)
    -   https://github.com/allfunc/docker-mdbook/tree/main/mdbook-demo/src/public
-   sample import HTML file
    -   https://github.com/allfunc/docker-mdbook/blob/main/mdbook-demo/src/public/import-demo.html

## APP

### mdbook

-   https://github.com/rust-lang/mdBook
-   https://crates.io/crates/mdbook
-   DOC http://rust-lang-nursery.github.io/mdBook/index.html

### mdbook-toc

-   https://github.com/badboy/mdbook-toc
-   https://crates.io/crates/mdbook-toc

### mdbook-mermaid

-   https://github.com/badboy/mdbook-mermaid
-   https://crates.io/crates/mdbook-mermaid

### mdbook-plantuml

-   https://github.com/sytsereitsma/mdbook-plantuml
-   https://crates.io/crates/mdbook-plantuml
-   https://plantuml.com/
-   https://the-lum.github.io/puml-themes-gallery/diagrams/index.html

### mdbook-pandoc
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

-   SUMMARY.md
    -   https://rust-lang.github.io/mdBook/format/summary.html
-   Render
    -   https://rust-lang.github.io/mdBook/format/configuration/renderers.html

MIT 2023
