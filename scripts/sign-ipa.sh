#!/bin/bash
set -euo pipefail
SIGN_DIR="$RUNNER_TEMP/ios-signing"
mkdir -p "$SIGN_DIR" output/Payload
KEYCHAIN="$SIGN_DIR/build.keychain-db"
KEYCHAIN_PASSWORD=$(openssl rand -hex 24)
cleanup() {
  security delete-keychain "$KEYCHAIN" >/dev/null 2>&1 || true
  rm -rf "$SIGN_DIR"
}
trap cleanup EXIT
printf '%s' "$IOS_P12_BASE64" | base64 --decode > "$SIGN_DIR/signing.p12"
printf '%s' "$IOS_PROFILE_BASE64" | base64 --decode > "$SIGN_DIR/profile.mobileprovision"
security cms -D -i "$SIGN_DIR/profile.mobileprovision" > "$SIGN_DIR/profile.plist"
security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
security set-keychain-settings -lut 21600 "$KEYCHAIN"
security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
security import "$SIGN_DIR/signing.p12" -P "$IOS_P12_PASSWORD" -A -t cert -f pkcs12 -k "$KEYCHAIN"
security set-key-partition-list -S apple-tool:,apple:,codesign: -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN" >/dev/null
curl -fsSL https://www.apple.com/certificateauthority/AppleWWDRCAG3.cer -o "$SIGN_DIR/AppleWWDRCAG3.cer"
security import "$SIGN_DIR/AppleWWDRCAG3.cer" -k "$KEYCHAIN" -t cert
security list-keychains -d user -s "$KEYCHAIN" "$HOME/Library/Keychains/login.keychain-db"
IDENTITY=$(security find-identity -v -p codesigning "$KEYCHAIN" | awk '/"/{print $2; exit}')
test -n "$IDENTITY"
export SIGN_DIR
python3 - <<'PY'
import os, plistlib, datetime
from pathlib import Path
p=Path(os.environ['SIGN_DIR'])
profile=plistlib.loads((p/'profile.plist').read_bytes())
if profile['ExpirationDate'] < datetime.datetime.now(datetime.timezone.utc).replace(tzinfo=None):
    raise SystemExit('Provisioning profile expired')
if not profile.get('ProvisionsAllDevices'):
    raise SystemExit('An enterprise profile is required for this distribution')
ent=profile['Entitlements']
team=profile['TeamIdentifier'][0]
prefix=profile['ApplicationIdentifierPrefix'][0]+'.'
identifier=ent['application-identifier'][len(prefix):]
if '*' in identifier:
    identifier='com.DefaultCompany.DragonBoy9'
signed_ent={
    'application-identifier':prefix+identifier,
    'com.apple.developer.team-identifier':team,
    'get-task-allow':False,
}
if 'keychain-access-groups' in ent:
    signed_ent['keychain-access-groups']=[v.replace('*',identifier) for v in ent['keychain-access-groups']]
(p/'entitlements.plist').write_bytes(plistlib.dumps(signed_ent))
(p/'bundle-id').write_text(identifier)
print('Signing bundle:',identifier)
print('Profile expiration:',profile['ExpirationDate'].isoformat())
PY
APP_SOURCE=$(find "$RUNNER_TEMP/DerivedData/Build/Products/Release-iphoneos" -maxdepth 1 -name '*.app' -type d -print -quit)
test -n "$APP_SOURCE"
ditto "$APP_SOURCE" output/Payload/ChienBinhVegeta.app
APP=output/Payload/ChienBinhVegeta.app
BUNDLE_ID=$(cat "$SIGN_DIR/bundle-id")
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BUNDLE_ID" "$APP/Info.plist"
cp "$SIGN_DIR/profile.mobileprovision" "$APP/embedded.mobileprovision"
while IFS= read -r -d '' code; do
  codesign --force --sign "$IDENTITY" --keychain "$KEYCHAIN" --timestamp=none "$code"
done < <(find "$APP" -depth \( -name '*.framework' -o -name '*.dylib' \) -print0)
codesign --force --sign "$IDENTITY" --keychain "$KEYCHAIN" --entitlements "$SIGN_DIR/entitlements.plist" --timestamp=none "$APP"
codesign --verify --deep --strict --verbose=2 "$APP"
codesign -d --entitlements :- "$APP" > output/signed-entitlements.plist
python3 - <<'PY'
import os,plistlib,json
from pathlib import Path
app=Path('output/Payload/ChienBinhVegeta.app')
info=plistlib.loads((app/'Info.plist').read_bytes())
profile=plistlib.loads((Path(os.environ['SIGN_DIR'])/'profile.plist').read_bytes())
Path('output/build-info.json').write_text(json.dumps({
 'bundle_id':info['CFBundleIdentifier'],
 'version':info['CFBundleShortVersionString'],
 'title':info.get('CFBundleDisplayName','ChienBinhVegeta'),
 'profile_expiration':profile['ExpirationDate'].isoformat(),
 'profile_type':'enterprise',
 'signature_verified':True
},indent=2))
PY
(cd output && ditto -c -k --sequesterRsrc --keepParent Payload ChienBinhVegeta-signed.ipa)
rm -rf output/Payload
shasum -a 256 output/ChienBinhVegeta-signed.ipa > output/SHA256SUMS.txt
