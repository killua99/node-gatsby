#!/usr/bin/env bash

set -e

POSITIONAL=()

REPO="killua99/node-gatsby"

while [[ $# -gt 0 ]]; do
    key="$1"

    case "$key" in
        -h|--help)
            cat <<EOF

Comman usage:

./build.sh [<version>] --latest -d|--debug -h|--help

Arguments:

  🔰 version        Node version. Ex: 13

Options:

  🔰 latest         Tag build latest
  🔰 d|--debug      Print run time commands
  🔰 h|--help       Print this message

Help:

  This bash script is a helper to tag new mastodon build using alpine as base
  full usage example:

    ``./build.sh 13 --latest``

    ``./build.sh 12 --debug``

EOF
            exit 0
            ;;
        --latest)
            LATEST="-t ${REPO}:latest"
            shift
            ;;
        -d|--debug)
            set -x
            shift
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done

set -- "${POSITIONAL[@]}"

NODE="${1:-13}"
TAG="${1:-latest}"
LATEST=${LATEST:-""}

cat <<EOF

We're about to build docker 🚢 image for the next platforms:

    📌 linux/amd64
    📌 linux/arm64
    📌 linux/arm/v7

If you wish to build for only one platform please ask for help: ``./build.sh -h|--help``

EOF

time docker buildx build \
    --push \
    --build-arg NODE_VERSION=${NODE} \
    --platform linux/amd64,linux/arm64,linux/arm/v7 \
    ${LATEST} \
    -t ${REPO}:${TAG} .
