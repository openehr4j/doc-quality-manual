#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

###############################################################################
# Handle script parameters
###############################################################################

function usage()
{
    cat <<-END
usage: $(basename -- "$BASH_SOURCE") -v VERSION -b BUILD_DIR [-h]

required arguments:
  -v    The version number of the published release.
  -b    The directory where the compiled HTML and PDF should be moved to.

optional arguments:
  -h    Show this help message and exit.

END
}

while getopts "h v: b:" o; do
  case "${o}" in
    v)
      VERSION=${OPTARG}
      ;;
    b)
      BUILD_DIR=${OPTARG}
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

if [[ -z "${BUILD_DIR}" ]] ; then
  echo -e "ERROR: Missing required parameter '-b'.\n" >&2
  usage
  exit 1
fi

###############################################################################
# Functions
###############################################################################

function has_untracked_files() {
  local UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
  [[ ! -z "${UNTRACKED_FILES}" ]]
}

###############################################################################
# Main
###############################################################################

cd ${SCRIPT_DIR}/../..

if has_untracked_files ; then
  echo "ERROR: when this script gets called, there should be no untracked files" >&2
  exit 1
fi

echo
echo "Compile HTML"
echo
if [[ -d ./build ]]; then
  rm -r ./build
fi
mkdir ./build
find src -name "img" -exec cp -r {} ./build \;
docker run -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor ./src/index.adoc --out-file ./build/quality-manual.html
mv ./build ${BUILD_DIR}/html

echo
echo "Compile PDF"
echo
mkdir ./build
find src -name "img" -exec cp -r {} ./src \;
docker run -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf ./src/index.adoc --out-file ./build/quality-manual.pdf
rm $(git ls-files --others --exclude-standard) && rmdir ./src/img 2> /dev/null # remove untracked files
mkdir ${BUILD_DIR}/pdf
mv ./build/quality-manual.pdf ${BUILD_DIR}/pdf/
