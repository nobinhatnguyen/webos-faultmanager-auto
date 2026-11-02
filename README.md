# LG webOS TV — Hướng dẫn SSH, Root & Nobi Launcher

**Phiên bản hiện tại: v1.1.1** (2026-11-02) · [Lịch sử phiên bản](#lịch-sử-phiên-bản)

Hướng dẫn từng bước để kết nối SSH, root LG webOS TV bằng `faultmanager-autoroot`, thiết lập Homebrew Channel và tùy chỉnh launcher Luma. Có lệnh cho **macOS** và **Windows**, cùng ô nhập IP TV và đường dẫn file để tự tạo lệnh phù hợp.

Repository còn kèm **tvopt**, script dọn và tối ưu TV (xem [bên dưới](#dọn-và-tối-ưu-tv-tvopt)), và **Nobi Launcher**, launcher thay màn hình chính của TV sau khi đã root (xem [bên dưới](#nobi-launcher)).

**Thứ tự nên làm:** root TV → dọn và tối ưu bằng tvopt → cài Nobi Launcher.

## Dọn và tối ưu TV (tvopt)

Nên chạy **trước khi cài launcher**. Thư mục [`tv-optimize/`](./tv-optimize/) gồm hai phần:

- **Không cần root:** danh sách mục cần tắt trong Cài đặt của TV (Quick Start+, quảng cáo trên Home, Live Plus, AirPlay, DNS chặn quảng cáo…).
- **TV đã root:** script `tvopt.sh` chạy thẳng trên TV và tự chạy lại mỗi lần bật TV. Script chặn tên miền quảng cáo LG, chặn cập nhật firmware, tắt telnet root không mật khẩu, tắt AirPlay/HomeKit và đóng Netflix/YouTube nạp sẵn ở nền. Script không đóng app đang xem và không ghi vào phân vùng hệ thống.

| File | Nội dung |
| --- | --- |
| [`tvopt.sh`](./tv-optimize/tvopt.sh) | Script tối ưu, chạy trên TV bằng root (`install` · `status` · `apply` · `uninstall`). |
| [`README.html`](./tv-optimize/README.html) | Hướng dẫn có ô nhập IP để tự tạo lệnh (mở bằng trình duyệt sau khi tải ZIP). |
| [`README.md`](./tv-optimize/README.md) | Cùng nội dung, đọc trực tiếp trên GitHub. |

Cài nhanh (macOS/Linux, trong thư mục `tv-optimize`, thay `<IP-TV>` bằng IP của TV):

```bash
ssh root@<IP-TV> "tr -d '\r' > /tmp/tvopt.sh" < tvopt.sh
ssh root@<IP-TV> sh /tmp/tvopt.sh install
```

> Đã thử trên LG UK6340PTF, webOS TV Lite 4.4.3: RAM khả dụng sau khi bật TV tăng từ khoảng 145 MB lên 340 MB.

## Nobi Launcher

**Nobi Launcher** thay màn hình chính của TV LG webOS bằng giao diện gọn, nhanh, dễ dùng bằng remote:

- Dock kiểu macOS, Control Center (Wi-Fi, Bluetooth, âm lượng, đèn nền, tắt màn hình).
- Trang chủ có đồng hồ lớn, âm lịch kèm con giáp và thời tiết.
- Thay nút Home, tự mở khi bật TV, video YouTube thu nhỏ vào dock khi bấm Home.
- Đi kèm **Nobi Remote**: webapp điều khiển TV ngay trên điện thoại (phím điều hướng, gõ chữ, tìm bằng giọng nói, Wi-Fi, hẹn giờ tắt, đổi hình nền).

File cài và hướng dẫn nằm trong thư mục [`nobi-launcher/`](./nobi-launcher/):

| File | Nội dung |
| --- | --- |
| [`com.nobi.launcher_1.1.1_arm.ipk`](./nobi-launcher/com.nobi.launcher_1.1.1_arm.ipk) | File cài Nobi Launcher, đã gồm Nobi Remote. |
| [`SHA256SUMS`](./nobi-launcher/SHA256SUMS) | Mã kiểm tra file tải về. |
| [`CHANGELOG.md`](./nobi-launcher/CHANGELOG.md) | Thay đổi của từng phiên bản Nobi Launcher. |
| [`README.html`](./nobi-launcher/README.html) | Hướng dẫn cài đặt và sử dụng (mở bằng trình duyệt sau khi tải ZIP). |
| [`README.md`](./nobi-launcher/README.md) | Cùng nội dung, đọc trực tiếp trên GitHub. |

> **Yêu cầu:** TV đã root và cài Homebrew Channel (làm theo hướng dẫn root ở trên). Nên chạy [tvopt](#dọn-và-tối-ưu-tv-tvopt) trước khi cài. Bản này mới được thử trên LG UK6340PTF, webOS TV Lite 4.4.3. Nobi Launcher dựa trên [lg-luma](https://github.com/ecklf/lg-luma) của ecklf (MIT).

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
- **tvopt:** [`tv-optimize/README.html`](./tv-optimize/README.html) · [`tv-optimize/README.md`](./tv-optimize/README.md).
- **Nobi Launcher:** [`nobi-launcher/README.html`](./nobi-launcher/README.html) · [`nobi-launcher/README.md`](./nobi-launcher/README.md).

## Lịch sử phiên bản

### v1.1.1 — 2026-11-02

- Nobi Launcher và repo này dùng chung một số phiên bản: file cài đổi tên thành `com.nobi.launcher_1.1.1_arm.ipk`. Không đổi tính năng so với v1.1.0.

### v1.1.0 — 2026-11-02

- Cập nhật Nobi Launcher lên 1.0.1: nhanh và nhẹ hơn trên TV, file cài còn 12 MB.
- Control Center hiện âm lượng, đèn nền gần như tức thì; sửa lỗi mục Tích hợp báo TV chưa root.
- Thêm nhật ký thay đổi của Nobi Launcher: [`nobi-launcher/CHANGELOG.md`](./nobi-launcher/CHANGELOG.md).

### v1.0.0 — 2026-11-02

- Bắt đầu đánh số phiên bản và ghi lịch sử thay đổi cho mỗi lần cập nhật.
- Gồm: hướng dẫn root và SSH (macOS/Windows), tvopt dọn và tối ưu TV, Nobi Launcher 2.10.3 kèm Nobi Remote.

## Cảnh báo

Root TV có thể gây lỗi hệ thống, ảnh hưởng bảo hành và làm tăng rủi ro bảo mật. Chỉ thao tác trên thiết bị bạn sở hữu hoặc được phép quản trị. Không chia sẻ SSH private key, mật khẩu hoặc passphrase. Không chạy script khi chưa xác minh firmware tương thích.

---

**Biên soạn:** [Nobi Nhật Nguyễn](https://github.com/nobinhatnguyen)  
*Ghi nhận tác giả và các dự án gốc qua các liên kết ở trên.*
