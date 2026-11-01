# LG webOS TV — Hướng dẫn SSH, Root & Nobi Launcher

Hướng dẫn từng bước để kết nối SSH, root LG webOS TV bằng `faultmanager-autoroot`, thiết lập Homebrew Channel và tùy chỉnh launcher Luma. Có lệnh cho **macOS** và **Windows**, cùng ô nhập IP TV và đường dẫn file để tự tạo lệnh phù hợp.

Repository còn kèm **Nobi Launcher**, launcher thay màn hình chính của TV sau khi đã root (xem [bên dưới](#nobi-launcher)).

## Nobi Launcher

**Nobi Launcher** thay màn hình chính của TV LG webOS bằng giao diện gọn, nhanh, dễ dùng bằng remote:

- Dock kiểu macOS, Control Center (Wi-Fi, Bluetooth, âm lượng, đèn nền, tắt màn hình).
- Trang chủ có đồng hồ lớn, âm lịch kèm con giáp và thời tiết.
- Thay nút Home, tự mở khi bật TV, video YouTube thu nhỏ vào dock khi bấm Home.
- Đi kèm **Nobi Remote**: webapp điều khiển TV ngay trên điện thoại (phím điều hướng, gõ chữ, tìm bằng giọng nói, Wi-Fi, hẹn giờ tắt, đổi hình nền).

File cài và hướng dẫn nằm trong thư mục [`nobi-launcher/`](./nobi-launcher/):

| File | Nội dung |
| --- | --- |
| [`com.nobi.launcher_2.10.3_arm.ipk`](./nobi-launcher/com.nobi.launcher_2.10.3_arm.ipk) | File cài Nobi Launcher, đã gồm Nobi Remote. |
| [`SHA256SUMS`](./nobi-launcher/SHA256SUMS) | Mã kiểm tra file tải về. |
| [`README.html`](./nobi-launcher/README.html) | Hướng dẫn cài đặt và sử dụng (mở bằng trình duyệt sau khi tải ZIP). |
| [`README.md`](./nobi-launcher/README.md) | Cùng nội dung, đọc trực tiếp trên GitHub. |

> **Yêu cầu:** TV đã root và cài Homebrew Channel (làm theo hướng dẫn root ở trên). Bản này mới được thử trên LG UK6340PTF, webOS TV Lite 4.4.3. Nobi Launcher dựa trên [lg-luma](https://github.com/ecklf/lg-luma) của ecklf (MIT).

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
- **Nobi Launcher:** [`nobi-launcher/README.html`](./nobi-launcher/README.html) · [`nobi-launcher/README.md`](./nobi-launcher/README.md).

## Cảnh báo

Root TV có thể gây lỗi hệ thống, ảnh hưởng bảo hành và làm tăng rủi ro bảo mật. Chỉ thao tác trên thiết bị bạn sở hữu hoặc được phép quản trị. Không chia sẻ SSH private key, mật khẩu hoặc passphrase. Không chạy script khi chưa xác minh firmware tương thích.

---

**Biên soạn:** [Nobi Nhật Nguyễn](https://github.com/nobinhatnguyen)  
*Ghi nhận tác giả và các dự án gốc qua các liên kết ở trên.*
