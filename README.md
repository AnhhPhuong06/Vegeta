# ChienBinhVegeta — iOS

Unity iOS export, including the IL2CPP toolchain and Xcode project.

- [Install on iPhone](https://anhhphuong06.github.io/Vegeta/)
- [Download signed IPA](https://github.com/AnhhPhuong06/Vegeta/releases/download/ios-20261022/ChienBinhVegeta-signed.ipa)

The enterprise provisioning profile for this release expires on **5 November 2026**.

## Build

Clone with Git LFS installed, then open `Unity-iPhone.xcodeproj` on a Mac with Xcode. The library `Libraries/libiPhone-lib.a` is stored with Git LFS.

The **Build signed iOS IPA** GitHub Actions workflow can also be started manually. Configure `IOS_P12_BASE64`, `IOS_PROFILE_BASE64`, and `IOS_P12_PASSWORD` as repository secrets before running it. The workflow uses the bundle identifier permitted by the supplied provisioning profile and verifies the resulting signature.

Signing credentials are excluded from version control.
