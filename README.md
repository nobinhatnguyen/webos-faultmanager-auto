# LG webOS TV — Hướng dẫn SSH, Root & Luma

Hướng dẫn từng bước để kết nối SSH, root LG webOS TV bằng `faultmanager-autoroot`, thiết lập Homebrew Channel và tùy chỉnh launcher Luma. Có lệnh cho **macOS** và **Windows**, cùng ô nhập IP TV và đường dẫn file để tự tạo lệnh phù hợp.

## Bắt đầu nhanh

1. Nhấn **[Code → Download ZIP](https://github.com/nobinhatnguyen/webos-faultmanager-auto/archive/refs/heads/main.zip)** để tải toàn bộ repository.
2. Giải nén file ZIP vừa tải.
3. Mở thư mục đã giải nén và **nhấp đúp vào `README.html`** để xem hướng dẫn bằng trình duyệt (Chrome, Safari hoặc Edge).
4. Làm theo các bước trên trang: nhập **IP TV**, chọn tab **macOS / Windows**, rồi sao chép lệnh tương ứng.

> **Lưu ý:** Nếu repository chỉ có `index.html` thay vì `README.html`, hãy mở `index.html`. Để người dùng thực hiện đúng bước 3, hãy bảo đảm file hướng dẫn được đặt tên `README.html` trước khi push lên GitHub.

## Những gì bạn cần

- TV LG chạy webOS, máy tính macOS hoặc Windows cùng mạng LAN/Wi-Fi.
- Tài khoản LG Developer và ứng dụng Developer Mode trên TV (nếu cần thực hiện từ đầu).
- Kiểm tra **model và firmware** tại [CanI.RootMy.TV](https://cani.rootmy.tv/) trước khi thử root.
- File `autoroot.sh` từ repository này, nếu bạn làm theo quy trình tải script về máy.

## Xem mã nguồn và tài liệu

- **Repository:** https://github.com/nobinhatnguyen/webos-faultmanager-auto
- **Hướng dẫn HTML:** [`README.html`](./README.html) (mở file sau khi tải ZIP để sử dụng đầy đủ các tính năng tương tác).
- **Dự án gốc:** [throwaway96/faultmanager-autoroot](https://github.com/throwaway96/faultmanager-autoroot).
- **Homebrew Channel:** [webosbrew/webos-homebrew-channel](https://github.com/webosbrew/webos-homebrew-channel).
- **Luma launcher:** [ecklf/lg-luma](https://github.com/ecklf/lg-luma).

## Cảnh báo

Root TV có thể gây lỗi hệ thống, ảnh hưởng bảo hành và làm tăng rủi ro bảo mật. Chỉ thao tác trên thiết bị bạn sở hữu hoặc được phép quản trị. Không chia sẻ SSH private key, mật khẩu hoặc passphrase. Không chạy script khi chưa xác minh firmware tương thích.

---

**Biên soạn:** [Nobi Nhật Nguyễn](https://github.com/nobinhatnguyen)  
*Ghi nhận tác giả và các dự án gốc qua các liên kết ở trên.*
