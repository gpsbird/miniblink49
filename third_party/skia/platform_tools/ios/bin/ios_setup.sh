#!/bin/bash
###############################################################################
# Copyright 2015 Google Inc.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
###############################################################################
#
# ios_setup.sh: Sets environment variables used by other iOS scripts.

# File system location where we mount the ios devices.
IOS_MOUNT_POINT="/tmp/mnt_iosdevice"

# Location on the ios device where all data are stored. This is
# relative to the mount point.
IOS_DOCS_DIR="Documents"

# Temporary location to assemble the app into an .ipa package.
IOS_PCKG_DIR="/tmp/ios_pckg"

# Bundle id of the app that runs the tests.
TEST_RUNNER_BUNDLE_ID="com.google.iOSShell"

# Directory with the Skia source.
SKIA_SRC_DIR=$(cd "${SCRIPT_DIR}/../../.."; pwd)

# Provisioning profile - this needs to be set up on the local machine.
PROVISIONING_PROFILE="9e88090d-abed-4e89-b106-3eff3512d31f"

# Code Signing identity - this needs to be set up on the local machine.
CODE_SIGN_IDENTITY="iPhone Developer: Google Development (3F4Y5873JF)"

IOS_BUNDLE_ID="com.google.iOSShell"

IOS_RESULTS_DIR="results"

# BUILDTYPE is 'Debug' by default.
if [[ -z "$BUILDTYPE" ]]; then
  BUILDTYPE="Debug"
fi

# Out dir is $SKIA_SRC_DIR/out by default. 
if [[ -z "$SKIA_OUT" ]]; then 
  SKIA_OUT="$SKIA_SRC_DIR/out"
fi 

ios_uninstall_app() {
  ideviceinstaller -U "$IOS_BUNDLE_ID"
}

ios_install_app() {
  rm -rf $IOS_PCKG_DIR
  mkdir -p $IOS_PCKG_DIR/Payload  # this directory must be named 'Payload'
  cp -rf "${SKIA_SRC_DIR}/xcodebuild/${BUILDTYPE}-iphoneos/iOSShell.app" "${IOS_PCKG_DIR}/Payload/"
  local RET_DIR=`pwd`
  cd $IOS_PCKG_DIR
  zip -r iOSShell.ipa Payload
  ideviceinstaller -i ./iOSShell.ipa
  cd $RET_DIR
}

ios_rm() {
  local TARGET="$IOS_MOUNT_POINT/$IOS_DOCS_DIR/$1"

  ios_mount
  rm -rf "$TARGET"
  ios_umount
}

ios_mkdir() {
  local TARGET="$IOS_MOUNT_POINT/$IOS_DOCS_DIR/$1"
  ios_mount
  mkdir -p "$TARGET"
  ios_umount
}

ios_cat() {
  local TARGET="$IOS_MOUNT_POINT/$IOS_DOCS_DIR/$1"
  ios_mount
  RET="$(cat $TARGET)"
  ios_umount
  echo -e "$RET"
}

# ios_mount: mounts the iOS device for reading or writing.
ios_mount() {
  # If this is already mounted we unmount it.
  if $(mount | grep --quiet "$IOS_MOUNT_POINT"); then
    >&2 echo "Device already mounted at: $IOS_MOUNT_POINT - Unmounting."
    ios_umount || true   
  fi

  # Ensure there is a mount directory.
  if [[ ! -d "$IOS_MOUNT_POINT" ]]; then
    mkdir -p $IOS_MOUNT_POINT
  fi
  ifuse --container $TEST_RUNNER_BUNDLE_ID $IOS_MOUNT_POINT
  sleep 1
  >&2 echo "Successfully mounted device."
}

# ios_umount: unmounts the ios device.
ios_umount() {
  umount $IOS_MOUNT_POINT
  sleep 1
}

# ios_restart: restarts the iOS device.
ios_restart() {
  ios_umount || true 
  idevicediagnostics restart
}

# ios_pull(ios_src, host_dst): Copies the content of ios_src to host_dst.
# The path is relative to the 'Documents' folder on the device.
ios_pull() {
  # read input params
  local IOS_SRC="$IOS_MOUNT_POINT/$IOS_DOCS_DIR/$1"
  local HOST_DST="$2"

  ios_mount
  if [[ -d "${HOST_DST}" ]]; then
    cp -r "$IOS_SRC/" "$HOST_DST"
  else
    cp -r "$IOS_SRC" "$HOST_DST"
  fi
  ios_umount
}

# ios_push(host_src, ios_dst)
ios_push() {
  # read input params
  local HOST_SRC="$1"
  local IOS_DST="$IOS_MOUNT_POINT/$IOS_DOCS_DIR/$2"

  ios_mount
  rm -rf $IOS_DST
  mkdir -p "$(dirname $IOS_DST)"
  cp -r "$HOST_SRC" "$IOS_DST"
  ios_umount
}

ios_path_exists() {
  local TARGET_PATH="$IOS_MOUNT_POINT/$IOS_DOCS_DIR/$1"
  local RET=1
  ios_mount
  if [[ -e $TARGET_PATH ]]; then
    RET=0
  fi
  ios_umount
  return $RET
}

#   ANDROID_LS=`$ADB $DEVICE_SERIAL shell ls -ld $ANDROID_DST`
#   HOST_LS=`ls -ld $HOST_SRC`
#   if [ "${ANDROID_LS:0:1}" == "d" -a "${HOST_LS:0:1}" == "-" ];
#   then
#     ANDROID_DST="${ANDROID_DST}/$(basename ${HOST_SRC})"
#   fi


#   ANDROID_LS=`$ADB $DEVICE_SERIAL shell ls -ld $ANDROID_DST`
#   if [ "${ANDROID_LS:0:1}" == "-" ]; then
#     #get the MD5 for dst and src
#     ANDROID_MD5=`$ADB $DEVICE_SERIAL shell md5 $ANDROID_DST`
#     if [ $(uname) == "Darwin" ]; then
#       HOST_MD5=`md5 -q $HOST_SRC`
#     else
#       HOST_MD5=`md5sum $HOST_SRC`
#     fi

#     if [ "${ANDROID_MD5:0:32}" != "${HOST_MD5:0:32}" ]; then
#       echo -n "$ANDROID_DST "
#       $ADB $DEVICE_SERIAL push $HOST_SRC $ANDROID_DST
#     fi
#   elif [ "${ANDROID_LS:0:1}" == "d" ]; then
#     for FILE_ITEM in `ls $HOST_SRC`; do
#       adb_push_if_needed "${HOST_SRC}/${FILE_ITEM}" "${ANDROID_DST}/${FILE_ITEM}"
#     done
#   else
#     HOST_LS=`ls -ld $HOST_SRC`
#     if [ "${HOST_LS:0:1}" == "d" ]; then
#       $ADB $DEVICE_SERIAL shell mkdir -p $ANDROID_DST
#       adb_push_if_needed $HOST_SRC $ANDROID_DST
#     else
#       echo -n "$ANDROID_DST "
#       $ADB $DEVICE_SERIAL shell mkdir -p "$(dirname "$ANDROID_DST")"
#       $ADB $DEVICE_SERIAL push $HOST_SRC $ANDROID_DST
#     fi
#   fi
# }

# setup_device "${DEVICE_ID}"
