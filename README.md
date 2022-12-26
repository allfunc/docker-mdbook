[![CircleCI](https://circleci.com/gh/HillLiu/docker-mdbook/tree/main.svg?style=svg)](https://circleci.com/gh/HillLiu/docker-mdbook/tree/main)
[![Docker Pulls](https://img.shields.io/docker/pulls/hillliu/mdbook.svg)](https://hub.docker.com/r/hillliu/mdbook)

# `docker-mdbook` (Alpine)

> A set of tool for mdbook. 

## How to use?
1. create SUMMARY.md file with such content.
```markdown
# Summary

- [Chapter 1](./chapter_1.md)
```
2. copy preview.sh to same folder.
   * or download https://raw.githubusercontent.com/HillLiu/docker-mdbook/main/preview.sh
4. run following command
```
./preview.sh start
```

### import html
   * create any folder (such as public) inside src folder
```
<div data-import="/public/import-demo.html"></div>
```
   * sample md file
      * https://raw.githubusercontent.com/HillLiu/docker-mdbook/main/mdbook-demo/src/importDemo_2.md
   * sample public folder (could be any)
      * https://github.com/HillLiu/docker-mdbook/tree/main/mdbook-demo/src/public
   * sample import html file
      * https://github.com/HillLiu/docker-mdbook/blob/main/mdbook-demo/src/public/import-demo.html
   

## APP
### mdbook
   * https://github.com/rust-lang-nursery/mdBook
   * https://crates.io/crates/mdbook
   * DOC http://rust-lang-nursery.github.io/mdBook/index.html
### mdbook-toc
   * https://github.com/badboy/mdbook-toc
   * https://crates.io/crates/mdbook-toc
### mdbook-mermaid
   * https://github.com/badboy/mdbook-mermaid
   * https://crates.io/crates/mdbook-mermaid
### mdbook-plantuml
   * https://github.com/sytsereitsma/mdbook-plantuml
   * https://crates.io/crates/mdbook-plantuml
   * https://plantuml.com/

## Docker hub
   * https://hub.docker.com/r/hillliu/mdbook
### update docker image
```
docker pull hillliu/mdbook
```
### Troubleshooting
```
docker run --rm hillliu/mdbook -V
```
