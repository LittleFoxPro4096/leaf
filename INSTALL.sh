#!/bin/bash
set -e
source leaf.conf

install -vdm755 $DIST_DIR $BUILD_DIR $PKGBUILD_DIR $TRACE_DIR $HOOK_DIR $BINARY_DIR $TEMP_DIR
touch $INSTALLED_PACKAGES
chmod -v 644 $INSTALLED_PACKAGES
install -vDm644 leaf.conf -t /etc
install -vDm755 leaf -t /usr/bin
