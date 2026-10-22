# Build IPA unsigned trên GitHub Actions

Workflow `.github/workflows/ios-unsigned-release.yml` tạo IPA unsigned trên runner macOS và đăng file thành GitHub Release công khai. Workflow không cần certificate, provisioning profile hoặc GitHub Actions secrets.

## Chạy workflow

Vào **Actions → Build and release unsigned iOS IPA → Run workflow**. Sau khi build thành công, tải file từ trang Releases hoặc dùng link trực tiếp:

`https://github.com/AnhhPhuong06/Vegeta/releases/latest/download/ChienBinhVegeta-unsigned.ipa`

IPA unsigned không thể cài trực tiếp trên iPhone. Hãy tự ký bằng Apple Developer team của bạn trước khi cài, dùng bundle ID `com.DefaultCompany.DragonBoy9` và profile tương ứng.
