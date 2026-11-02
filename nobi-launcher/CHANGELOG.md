# Nhật ký thay đổi — Nobi Launcher

Nobi Remote nằm chung gói với Nobi Launcher, nên dùng chung số phiên bản và chung nhật ký này. Từ 1.1.1, số phiên bản cũng trùng với repo hướng dẫn webos-faultmanager-auto.
Mỗi bản phát hành mới thêm một mục ở đầu file.

## 1.2.0 — 02/11/2026

### Trang Ứng dụng

- Icon app giờ là hình vuông bo góc kiểu macOS, mỗi hàng 10 app.
- Thêm hàng **Yêu thích** ở đầu trang. Bấm OK là mở app ngay. App yêu thích vẫn có trong danh sách bên dưới.
- Thêm mục **Tất cả** trước "Phim & video" để xem lại mọi app. Nút X bỏ lọc đã được bỏ.

### Cài đặt

- Mở Cài đặt từ dock là vào thẳng mục **Chung**.
- Khối menu nằm giữa khoảng trống giữa đồng hồ và dock.
- Đi lên nút Control Center rồi xuống lại, con trỏ về đúng mục vừa rời. Đi xuống dock rồi lên lại cũng vậy.
- Bấm xuống ở mục **Giới thiệu** thì con trỏ xuống dock, không còn vòng về "Chung".
- Tên app trong dock được bật sẵn. Tuỳ chọn ở Cài đặt › Chung › Tên ứng dụng đổi tên thành "Hiện ở dock trong Trang chủ" và "Hiện ở danh sách trong Ứng dụng". TV đã cài bản cũ giữ nguyên lựa chọn cũ.

### Tìm kiếm

- Trong lúc chờ LG trả kết quả, hàng kết quả hiện ô chờ. Bấm OK lúc này không mở nhầm YouTube.

### Nobi Remote

- Ô trên cùng của tab Điều khiển giờ là thanh tìm kiếm. Gõ chữ rồi bấm Tìm là TV mở trang kết quả.
- Khi TV đang mở ô nhập chữ, thanh này tự chuyển sang gõ chữ lên TV. Bấm icon ở đầu ô để đổi chế độ bằng tay.
- Gõ chữ lên TV: bấm Enter thì bàn phím điện thoại tự ẩn, và chữ được giữ lại. Quay lại đúng ô đó trên TV thì gõ tiếp được, không phải nhập lại từ đầu.
- Điện thoại hiện bảng kết quả tìm kiếm giống trên TV. Chạm vào thẻ là TV mở nội dung đó, bấm X là đóng cả hai bên.
- Icon app trên điện thoại giống trên TV, ví dụ YouTube nền đen.

### Đã sửa

- Đã sửa lỗi để Nobi Launcher yên vài phút thì app chạy gần nhất tự hiện lên.

## 1.1.1 — 02/11/2026

- Số phiên bản của Nobi Launcher từ nay trùng với số phiên bản của repo hướng dẫn [webos-faultmanager-auto](https://github.com/nobinhatnguyen/webos-faultmanager-auto). File cài đổi tên thành `com.nobi.launcher_1.1.1_arm.ipk`.
- Không đổi tính năng so với 1.0.1.

## 1.0.1 — 02/11/2026

Bản đầu tiên đánh số riêng cho Nobi Launcher. Các gói trước mang số `2.10.3` của lg-luma, dự án gốc mà Nobi Launcher được tách ra.

### Nhanh hơn, nhẹ hơn trên TV

- Đã thu nhỏ gói cài từ 26 MB xuống 12 MB. Trên TV, app chiếm khoảng 28 MB thay vì 53 MB.
- Đã giới hạn bộ nhớ đồ hoạ trên TV: ảnh tối đa 24 MB, chữ tối đa 6 MB, nên bộ nhớ không còn tăng dần khi dùng lâu.
- Khi bạn xem YouTube hoặc app khác, Nobi Launcher chạy nền và gần như không dùng CPU (khoảng 0,07 %). Đồng thời nó trả lại phần bộ nhớ đồ hoạ không cần cho màn hình đang chờ.
- Đổi hình nền không còn khựng. Ảnh được giải mã ở nền, và hình nền cũ vẫn hiện cho đến khi hình nền mới sẵn sàng, kể cả khi bật Giảm chuyển động.
- Bấm Home mở Nobi Launcher nhanh hơn. Danh sách app chỉ được đọc lại sau khi bạn vừa cài hoặc gỡ app, hoặc sau 30 phút.
- Chọn app là app mở ngay, không phải chờ Nobi Launcher đọc xong danh sách app.
- Control Center hiện âm lượng, đèn nền, Wi-Fi và Bluetooth gần như tức thì. Trước đây bạn phải chờ 2–3 giây.
- Ảnh kết quả tìm kiếm được thu nhỏ đúng cỡ thẻ, nên tải nhanh hơn và tốn ít bộ nhớ hơn.

### Đã sửa

- Đã sửa lỗi Cài đặt › Hệ thống › Tích hợp đôi khi báo TV chưa root, dù TV đã root.
- Đã sửa lỗi trang Tích hợp đứng ở "…" khi bạn vào bằng phím mũi tên hoặc chuột.
- Quét Bluetooth không còn bỏ sót thiết bị chưa ghép đôi.

### Nobi Remote

- Ảnh nền gửi từ điện thoại chưa ghép mã PIN bị từ chối ngay, có báo lỗi rõ ràng. Daemon không còn nhận cả ảnh vào bộ nhớ rồi mới từ chối.
- Cho phép tối đa 48 kết nối cùng lúc. Kết nối gửi dữ liệu quá chậm bị đóng, để daemon luôn nhẹ.
- Mở lại trang trên điện thoại liên tục không còn khiến TV phải đọc lại trạng thái mỗi lần.

### Lưu ý

- Bản này bỏ font chữ Trung và chữ Hàn. Tên app viết bằng chữ Trung hoặc chữ Hàn sẽ thiếu ký tự. Giao diện chỉ có tiếng Anh và tiếng Việt nên không bị ảnh hưởng.
