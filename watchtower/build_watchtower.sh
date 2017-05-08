#!/bin/sh

CURDIR=`pwd`
GLIDE_SRC=$CURDIR/src/github.com/Masterminds/glide
WATCHTOWER_SRC=$CURDIR/src/github.com/v2tec/watchtower

mkdir -p $GLIDE_SRC $WATCHTOWER_SRC

git clone https://github.com/Masterminds/glide.git $GLIDE_SRC
git clone https://github.com/v2tec/watchtower.git $WATCHTOWER_SRC

# Build glide
cd $GLIDE_SRC
git checkout v0.12.3
env GOPATH=$CURDIR make build || exit 1
cp glide $WATCHTOWER_SRC

# Build watchtower
cd $WATCHTOWER_SRC
env GOPATH=$CURDIR ./glide install || exit 1
env GOPATH=$CURDIR GOARCH=arm go build || exit 1
cp watchtower $CURDIR
cd $CURDIR

rm -rf src

docker build --force-rm --no-cache -t cusdeb-watchtower-armhf .
