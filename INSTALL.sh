#!/usr/bin/env bash
set -e

cd "$(dirname "$(realpath "$0")")"
source leaf.conf

install -vdm755 $DIST_DIR $BUILD_DIR $PKGBUILD_DIR $TRACE_DIR $HOOK_DIR $BINARY_DIR $TEMP_DIR $LOG_DIR $LOG_DIR/build $LOG_DIR/transaction
touch $INSTALLED_PACKAGES $LOG_DIR/leaf.log
chmod -v 644 $INSTALLED_PACKAGES $LOG_DIR/leaf.log
install -vDm644 leaf.conf -t /etc
install -vDm755 leaf -t /usr/bin
