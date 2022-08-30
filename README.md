mdbook alpine
======
A set of tool for mdbook.

## How to use?
1. create SUMMARY.md file with such content.
```
# Summary

- [Chapter 1](./chapter_1.md)
```
2. copy preview.sh to same folder.
3. run following command
```
./preview.sh start
```

### import html
   * create any folder (such as public) inside src folder
```
<div data-import="/public/import-demo.html"></div>
```
   * sample md file
      * https://raw.githubusercontent.com/HillLiu/docker-mdbook/master/mdbook-demo/src/chapter_2.md
   * sample public folder (could be any)
      * https://github.com/HillLiu/docker-mdbook/tree/master/mdbook-demo/src/public
   * sample import html file
      * https://github.com/HillLiu/docker-mdbook/blob/master/mdbook-demo/src/public/import-demo.html
   

## APP
### mdbook
   * https://github.com/rust-lang-nursery/mdBook
   * DOC http://rust-lang-nursery.github.io/mdBook/index.html
### mdbook-toc
   * https://github.com/badboy/mdbook-toc
### mdbook-mermaid
   * https://github.com/badboy/mdbook-mermaid
### mdbook-plantuml
   * https://github.com/sytsereitsma/mdbook-plantuml
### mdbook-presentation-preprocessor 
   * https://github.com/FreeMasen/mdbook-presentation-preprocessor 

## Docker hub
   * https://hub.docker.com/r/hillliu/mdbook
### update docker image
```
docker pull hillliu/mdbook
```
### Troubleshooting
```
docker run --rm  hillliu/mdbook -V
```
