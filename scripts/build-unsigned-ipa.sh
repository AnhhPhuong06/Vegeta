#!/bin/bash
set -euo pipefail

cd "$CM_BUILD_DIR"
DERIVED_DATA="$CM_BUILD_DIR/build/DerivedData"
OUTPUT_DIR="$CM_BUILD_DIR/build/ipa"
PAYLOAD_DIR="$CM_BUILD_DIR/build/unsigned-payload/Payload"
LOG_DIR=/tmp/xcodebuild_logs

mkdir -p "$OUTPUT_DIR" "$LOG_DIR"
set -o pipefail
xcodebuild \
  -project "$CM_BUILD_DIR/$XCODE_PROJECT" \
  -scheme "$XCODE_SCHEME" \
  -configuration Release \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  ENABLE_USER_SCRIPT_SANDBOXING=NO \
  COMPILER_INDEX_STORE_ENABLE=NO \
  build 2>&1 | tee "$LOG_DIR/xcodebuild.log"

APP_SOURCE=$(find "$DERIVED_DATA/Build/Products/Release-iphoneos" -maxdepth 1 -type d -name '*.app' -print -quit)
if [ -z "$APP_SOURCE" ]; then
  echo 'Xcode finished without producing an iOS app.' >&2
  exit 1
fi

if [ -e "$APP_SOURCE/embedded.mobileprovision" ]; then
  echo 'The output unexpectedly contains a provisioning profile.' >&2
  exit 1
fi

rm -rf "$PAYLOAD_DIR"
mkdir -p "$PAYLOAD_DIR"
ditto "$APP_SOURCE" "$PAYLOAD_DIR/$(basename "$APP_SOURCE")"
ditto -c -k --sequesterRsrc --keepParent \
  "$CM_BUILD_DIR/build/unsigned-payload/Payload" \
  "$OUTPUT_DIR/ChienBinhVegeta-unsigned.ipa"

shasum -a 256 "$OUTPUT_DIR/ChienBinhVegeta-unsigned.ipa" \
  > "$OUTPUT_DIR/SHA256SUMS.txt"
echo "Unsigned IPA: $OUTPUT_DIR/ChienBinhVegeta-unsigned.ipa"
