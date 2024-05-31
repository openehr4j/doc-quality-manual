# Quality Manual

## Dependencies

- Text editor with Asciidoc plugin (e.g. VS Code and [asciidoctor.asciidoctor-vscode](https://marketplace.visualstudio.com/items?itemName=asciidoctor.asciidoctor-vscode))
- Docker

## Maintenance

### Compile PDF

```sh
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf ./src/index.adoc --out-file ./build/quality-manual.pdf
```

## References

- [Template: Quality Manual, Policy, Objectives | openregulatory.com](https://openregulatory.com/or_template/quality-manual-policy-objectives/) 
