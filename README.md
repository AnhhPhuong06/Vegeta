# ChienBinhVegeta — unsigned iOS IPA

Unity iOS export and Xcode project. GitHub Actions builds an **unsigned** device IPA and publishes it as a public GitHub Release without requesting signing credentials.

- [Build instructions](https://anhhphuong06.github.io/Vegeta/#huong-dan)
- [Download the latest unsigned IPA](https://github.com/AnhhPhuong06/Vegeta/releases/latest/download/ChienBinhVegeta-unsigned.ipa)
- [Run a new build](https://github.com/AnhhPhuong06/Vegeta/actions/workflows/ios-unsigned-release.yml)
- [View this repository](https://github.com/AnhhPhuong06/Vegeta)

## Build with GitHub Actions

1. Open **Actions → Build and release unsigned iOS IPA → Run workflow**.
2. Wait for the macOS build to finish.
3. Download `ChienBinhVegeta-unsigned.ipa` from the new GitHub Release.

The workflow downloads the Unity IL2CPP library from Git LFS and builds the `Unity-iPhone` scheme for `iphoneos` with code signing disabled. No Apple certificate, provisioning profile, or password is needed for the build.

An unsigned IPA is not ready to install on an iPhone. To run the app on a device, sign it using an Apple Developer team, a matching bundle ID, and the appropriate provisioning profile. See [Apple's instructions for distributing apps to registered devices](https://developer.apple.com/documentation/xcode/distributing-your-app-to-registered-devices).
