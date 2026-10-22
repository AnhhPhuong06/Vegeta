# Build IPA đã ký bằng GitHub Actions

Workflow `.github/workflows/ios-signed-release.yml` tạo bản IPA Ad Hoc trên runner macOS, kiểm tra chữ ký rồi đăng IPA thành GitHub Release công khai. Mỗi lần chạy thành công sẽ cập nhật URL tải ổn định:

`https://github.com/AnhhPhuong06/Vegeta/releases/latest/download/ChienBinhVegeta.ipa`

## Chuẩn bị signing assets

Trong Apple Developer team của bạn, tạo provisioning profile **Ad Hoc** cho App ID `com.DefaultCompany.DragonBoy9`, dùng chứng chỉ Apple Distribution tương ứng và thêm UDID các iPhone cần cài. Profile phải khớp bundle ID; workflow sẽ dừng nếu không khớp.

Trong GitHub, mở **Settings → Secrets and variables → Actions → New repository secret** và thêm ba secrets:

- `IOS_CERTIFICATE_BASE64`: nội dung Base64 của file `.p12` có private key.
- `IOS_CERTIFICATE_PASSWORD`: mật khẩu của file `.p12`.
- `IOS_PROVISIONING_PROFILE_BASE64`: nội dung Base64 của file `.mobileprovision`.

Không commit các file ký hoặc giá trị secret vào repository. Trên PowerShell, có thể mã hóa file thành một chuỗi Base64 để dán trực tiếp vào trường Secret:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes('D:\path\to\certificate.p12'))
[Convert]::ToBase64String([IO.File]::ReadAllBytes('D:\path\to\profile.mobileprovision'))
```

## Chạy workflow

Vào tab **Actions → Build and release signed iOS IPA → Run workflow**. Khi build và xác minh chữ ký thành công, workflow tạo GitHub Release; file IPA tải trực tiếp được tại URL ở đầu trang này. Ad Hoc chỉ cài được trên thiết bị có UDID nằm trong profile.
