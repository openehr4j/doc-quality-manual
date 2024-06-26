# Quality Manual

## Dependencies

- Text editor with Asciidoc plugin (e.g. VS Code and [asciidoctor.asciidoctor-vscode](https://marketplace.visualstudio.com/items?itemName=asciidoctor.asciidoctor-vscode))
- Docker

## Maintenance

### Compile HTML and PDF

```sh
VERSION=0.0.0
BUILD_DIR=$(mktemp -d)
./.github/scripts/compile.sh -v ${VERSION} -b ${BUILD_DIR}
```

## References

- [Template: Quality Manual, Policy, Objectives | openregulatory.com](https://openregulatory.com/or_template/quality-manual-policy-objectives/) 
