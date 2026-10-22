# ChienBinhVegeta — unsigned iOS IPA

Unity iOS export and Xcode project. The Codemagic workflow builds an **unsigned** device IPA without requesting signing credentials.

- [Build instructions](https://anhhphuong06.github.io/Vegeta/#huong-dan)
- [Open Codemagic](https://codemagic.io/apps)
- [View this repository](https://github.com/AnhhPhuong06/Vegeta)

## Build with Codemagic

1. Add this GitHub repository to your Codemagic account.
2. Select the `vegeta-ios-unsigned` workflow and start a build.
3. Download `ChienBinhVegeta-unsigned.ipa` in the build's Artifacts section.

The workflow runs Xcode 16.4, downloads the Unity IL2CPP library from Git LFS, and builds the `Unity-iPhone` scheme for `iphoneos` with code signing disabled. No Apple certificate, provisioning profile, or password is needed for the build.

An unsigned IPA is not ready to install on an iPhone. To run the app on a device, sign it using an Apple Developer team, a matching bundle ID, and the appropriate provisioning profile. See [Apple's instructions for distributing apps to registered devices](https://developer.apple.com/documentation/xcode/distributing-your-app-to-registered-devices).
