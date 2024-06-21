#!/bin/bash

TAG_NAME=0.0.1

RELEASE_ARTIFACT_DIR=$(mktemp -d)

# Compile HTML
if [[ -d ./build ]]; then
  rm -r ./build
fi
mkdir ./build
find src -name "img" -exec cp -r {} ./build \;
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor ./src/index.adoc --out-file ./build/quality-manual.html
mv ./build ${RELEASE_ARTIFACT_DIR}/html

# Compile PDF
mkdir ./build
find src -name "img" -exec cp -r {} ./src \;
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf ./src/index.adoc --out-file ./build/quality-manual.pdf
rm $(git ls-files --others --exclude-standard) # remove untracked files
mkdir ${RELEASE_ARTIFACT_DIR}/pdf
mv ./build/quality-manual.pdf ${RELEASE_ARTIFACT_DIR}/pdf/

find $RELEASE_ARTIFACT_DIR

# GH_PAGES_DIR=$(mktemp -d)
# gh repo clone openehr4j/quality-manual ${GH_PAGES_DIR} -- -b gh-pages --single-branch
