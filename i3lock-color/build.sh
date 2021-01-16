#!/bin/bash
autoreconf -fiv

BUILD_DIR=build/
rm -rf $BUILD_DIR
mkdir -vp $BUILD_DIR
cd $BUILD_DIR || { echo "cd $BUILD_DIR"; exit 127; }

../configure --prefix=/usr --sysconfdir=/etc

make
