#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
RELEASE_ARTIFACT_DIR=$(mktemp -d)
TODAY=$(date '+%Y-%m-%d')

###############################################################################
# Handle script parameters
###############################################################################

function usage()
{
    cat <<-END
usage: publish-gh-pages.sh -v VERSION [-h]

required arguments:
  -v    The version number of the published release.

optional arguments:
  -h    Show this help message and exit.

END
}

while getopts "h v:" o; do
  case "${o}" in
    v)
      VERSION=${OPTARG}
      ;;
    h | *)
      usage
      exit 0
      ;;
  esac
done
shift $((OPTIND-1))

if [[ -z "${VERSION}" ]] ; then
  echo -e "ERROR: Missing required parameter '-v'.\n" >&2
  usage
  exit 1
fi

###############################################################################
# Main
###############################################################################

cd ${SCRIPT_DIR}/../..

echo
echo "Compile HTML"
echo
if [[ -d ./build ]]; then
  rm -r ./build
fi
mkdir ./build
find src -name "img" -exec cp -r {} ./build \;
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor ./src/index.adoc --out-file ./build/quality-manual.html
mv ./build ${RELEASE_ARTIFACT_DIR}/html

echo
echo "Compile PDF"
echo
mkdir ./build
find src -name "img" -exec cp -r {} ./src \;
docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf ./src/index.adoc --out-file ./build/quality-manual.pdf
rm $(git ls-files --others --exclude-standard) && rmdir ./src/img 2> /dev/null # remove untracked files
mkdir ${RELEASE_ARTIFACT_DIR}/pdf
mv ./build/quality-manual.pdf ${RELEASE_ARTIFACT_DIR}/pdf/

echo
echo "Upload to GitHub Pages"
echo
GH_PAGES_DIR=$(mktemp -d)
gh repo clone openehr4j/quality-manual ${GH_PAGES_DIR} -- -b gh-pages --single-branch
cd ${GH_PAGES_DIR}
mv ${RELEASE_ARTIFACT_DIR} ${GH_PAGES_DIR}/${VERSION}
echo "| ${VERSION} | ${TODAY} | [quality-manual.html](./${VERSION}/html/quality-manual.html) | [quality-manual.pdf](./${VERSION}/pdf/quality-manual.pdf) |" >> index.md
git add .
git commit -m "Add release artifacts for version ${VERSION}"
git push origin gh-pages
