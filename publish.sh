#!/bin/bash

VERSION=0.0.1
RELEASE_ARTIFACT_DIR=$(mktemp -d)
TODAY=$(date '+%Y-%m-%d')

echo "##########################################################"
echo "Compile HTML"
echo "##########################################################"
if [[ -d ./build ]]; then
  rm -r ./build
fi
mkdir ./build
find src -name "img" -exec cp -r {} ./build \;
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor ./src/index.adoc --out-file ./build/quality-manual.html
mv ./build ${RELEASE_ARTIFACT_DIR}/html

echo "##########################################################"
echo "Compile PDF"
echo "##########################################################"
mkdir ./build
find src -name "img" -exec cp -r {} ./src \;
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf ./src/index.adoc --out-file ./build/quality-manual.pdf
rm $(git ls-files --others --exclude-standard) && rmdir ./src/img 2> /dev/null # remove untracked files
mkdir ${RELEASE_ARTIFACT_DIR}/pdf
mv ./build/quality-manual.pdf ${RELEASE_ARTIFACT_DIR}/pdf/

echo "##########################################################"
echo "Upload to GitHub Pages"
echo "##########################################################"
GH_PAGES_DIR=$(mktemp -d)
gh repo clone openehr4j/quality-manual ${GH_PAGES_DIR} -- -b gh-pages --single-branch
cd ${GH_PAGES_DIR}
mv ${RELEASE_ARTIFACT_DIR} ${GH_PAGES_DIR}/${VERSION}
echo "| ${VERSION} | ${TODAY} | [quality-manual.html](./${VERSION}/html/quality-manual.html) | [quality-manual.pdf](./${VERSION}/pdf/quality-manual.pdf) |" >> index.md
git add .
git commit -m "Add release artifacts for version ${VERSION}"
git push origin gh-pages
