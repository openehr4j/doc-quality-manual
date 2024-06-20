# Quality Manual

## Dependencies

- Text editor with Asciidoc plugin (e.g. VS Code and [asciidoctor.asciidoctor-vscode](https://marketplace.visualstudio.com/items?itemName=asciidoctor.asciidoctor-vscode))
- Docker

## Maintenance

### Compile HTML

```sh
rm -r ./build && mkdir ./build
find src -name "img" -exec cp -r {} ./build \;
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor ./src/index.adoc --out-file ./build/quality-manual.html
```

### Compile PDF

```sh
find src -name "img" -exec cp -r {} ./src \;
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf ./src/index.adoc --out-file ./build/quality-manual.pdf
rm $(git ls-files --others --exclude-standard) # remove untracked files
```

## References

- [Template: Quality Manual, Policy, Objectives | openregulatory.com](https://openregulatory.com/or_template/quality-manual-policy-objectives/) 
