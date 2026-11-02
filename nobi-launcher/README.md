# Nobi Launcher

Nobi Launcher thay màn hình chính của TV LG webOS bằng giao diện gọn, nhanh, dễ dùng bằng remote: dock kiểu macOS, Control Center, trang chủ có đồng hồ lớn, âm lịch và thời tiết. Đi kèm là **Nobi Remote**, webapp điều khiển TV ngay trên điện thoại.

Nobi Launcher dựa trên [lg-luma](https://github.com/ecklf/lg-luma) của ecklf (giấy phép MIT).

> [!WARNING]
> Bản này mới được thử trên **LG UK6340PTF, webOS TV Lite 4.4.3**. Các tính năng trong mục **Tích hợp** (thay nút Home, chạy nền) sửa cách TV hoạt động sau mỗi lần khởi động. Trên TV hoặc phiên bản webOS khác, hãy bật từng mục một và kiểm tra kỹ. Mọi mục đều tắt lại được (xem [Gỡ cài đặt](#gỡ-cài-đặt)).

## Mục lục

- [Trong thư mục này](#trong-thư-mục-này)
- [Yêu cầu](#yêu-cầu)
- [Cài đặt](#cài-đặt)
- [Bật tích hợp hệ thống](#bật-tích-hợp-hệ-thống)
- [Dùng trên TV](#dùng-trên-tv)
- [Nobi Remote: điều khiển từ điện thoại](#nobi-remote-điều-khiển-từ-điện-thoại)
- [Cập nhật](#cập-nhật)
- [Gỡ cài đặt](#gỡ-cài-đặt)
- [Xử lý sự cố](#xử-lý-sự-cố)

## Trong thư mục này

| File                                    | Nội dung                                                                        |
| --------------------------------------- | ------------------------------------------------------------------------------- |
| `com.nobi.launcher_<phiên bản>_arm.ipk` | File cài Nobi Launcher, đã gồm cả Nobi Remote. Nằm ngay trong thư mục này. |
| `SHA256SUMS`                            | Mã kiểm tra để chắc file tải về không bị hỏng.                                  |
| `README.md`                             | Hướng dẫn này.                                                                  |
| [`CHANGELOG.md`](./CHANGELOG.md)        | Thay đổi của từng phiên bản.                                                    |

Kiểm tra file sau khi tải (macOS hoặc Linux):

```bash
shasum -a 256 -c SHA256SUMS
```

## Yêu cầu

- TV LG chạy webOS (đã thử: webOS TV Lite 4.4.3).
- TV **đã root** và đã cài **Homebrew Channel**. Không root thì vẫn mở được Nobi Launcher như một app thường, nhưng không thay được nút Home, không tự mở khi bật TV và không dùng được Nobi Remote.
- Máy tính cùng mạng với TV để cài file `.ipk`.
- Điện thoại cùng mạng Wi-Fi với TV nếu dùng Nobi Remote.

Root TV và cài Homebrew Channel: làm theo hướng dẫn chính thức ở [rootmy.tv](https://rootmy.tv) và [webosbrew.org](https://www.webosbrew.org). Mỗi đời TV và firmware có cách root khác nhau, hãy đọc kỹ trước khi làm.

## Cài đặt

### Bước 1. Tắt Quick Start+

Trên TV, mở cài đặt của LG và tắt **Quick Start+**. Khi Quick Start+ bật, bấm nút nguồn chỉ đánh thức TV khỏi chế độ chờ, nên Nobi Launcher không tự mở lên được.

### Bước 2. Dọn và tối ưu TV (nên làm)

TV đã root thì chạy **tvopt** trước khi cài: chặn quảng cáo, tắt AirPlay nếu không dùng, đóng Netflix/YouTube nạp sẵn ở nền. Trên TV đã thử, RAM khả dụng tăng từ khoảng 145 MB lên 340 MB, Nobi Launcher có thêm bộ nhớ để chạy. Hướng dẫn đầy đủ: [`tv-optimize/README.md`](../tv-optimize/README.md).

```bash
ssh root@<IP-TV> "tr -d '\r' > /tmp/tvopt.sh" < ../tv-optimize/tvopt.sh
ssh root@<IP-TV> sh /tmp/tvopt.sh install
```

tvopt không đóng app đang hiển thị hay video đang phát (kể cả video YouTube thu nhỏ trong dock của Nobi Launcher). Gỡ bằng `sh /home/root/tvopt/tvopt.sh uninstall`.

### Bước 3. Cài file `.ipk`

Chọn một trong hai cách.

**Cách A: webOS Dev Manager (dễ nhất).** Tải [webOS Dev Manager](https://github.com/webosbrew/dev-manager-desktop) về máy tính, thêm TV theo hướng dẫn của Dev Manager, rồi dùng chức năng cài app (Install) và chọn file `com.nobi.launcher_<phiên bản>_arm.ipk`.

**Cách B: SSH bằng tài khoản root.** Chép file lên TV rồi cài bằng dịch vụ cài app của webOS:

```bash
scp com.nobi.launcher_1.2.0_arm.ipk root@<IP-TV>:/media/developer/temp/nobi-launcher.ipk
ssh root@<IP-TV>
luna-send -i luna://com.webos.appInstallService/dev/install '{"id":"com.nobi.launcher","ipkUrl":"/media/developer/temp/nobi-launcher.ipk","subscribe":true}'
```

Khi thấy `"state":"installed"` thì bấm `Ctrl+C` để thoát.

### Bước 4. Mở Nobi Launcher

Tìm **Nobi Launcher** trong danh sách app của TV và mở lên. Lần đầu mở, app đọc danh sách ứng dụng và đầu vào của TV, mất vài giây.

### Bước 5. Bật tích hợp

Vào **Cài đặt › Tích hợp** trong Nobi Launcher và bật các mục bạn cần (xem phần tiếp theo).

## Bật tích hợp hệ thống

**Cài đặt › Tích hợp** có 4 công tắc. Mỗi công tắc bật hoặc tắt một hook khởi động của Homebrew Channel, nên cần TV đã root. TV chưa root thì trang này chỉ hiện lời giải thích.

| Công tắc                                    | Tác dụng                                                                                                                                                                                   |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Nút Home mở Nobi Launcher**               | Bấm Home trên remote là mở Nobi Launcher; giữ Home vẫn mở danh sách app gần đây của LG. Có hiệu lực **sau khi khởi động lại TV**: bật xong, Nobi Launcher hỏi có khởi động lại ngay không. |
| **Tự mở khi bật TV**                        | Bật TV là Nobi Launcher hiện lên, khoảng một phút sau khi TV khởi động.                                                                                                                    |
| **Chạy nền trên app khác (video vào dock)** | Nobi Launcher chạy nền khi bạn mở app khác. Đang xem YouTube mà bấm Home thì video thu nhỏ vào ô đầu dock và vẫn phát.                                                                     |
| **Điều khiển từ điện thoại (Nobi Remote)**  | Bật máy chủ nhỏ trên TV để điện thoại điều khiển TV qua Wi-Fi.                                                                                                                             |

> [!IMPORTANT]
> Tắt các mục này trước khi gỡ Nobi Launcher, nhất là **Nút Home**. Nếu không, nút Home sẽ trỏ vào app đã bị gỡ.

## Dùng trên TV

### Trang chủ và dock

- **Trang chủ** hiện lời chào, giờ lớn, ngày, âm lịch kèm con giáp (khi dùng tiếng Việt) và thời tiết hôm nay.
- **Dock** ở đáy màn hình, có ở mọi trang. Bên trái là các app yêu thích, giữa là các đầu vào (Live TV, HDMI), bên phải là 3 biểu tượng trang: Trang chủ, Ứng dụng, Cài đặt. Mục đang chọn phóng to kiểu macOS và hiện tên phía trên.
- Đang xem YouTube khi bấm Home thì ô đầu dock là video thu nhỏ. Bấm OK trên ô đó để quay lại xem toàn màn hình.

### Thao tác với app

- **OK**: mở app.
- **Giữ OK trên một app ở dock**: vào chế độ sắp xếp, dùng Trái/Phải để đổi chỗ, bấm OK hoặc Back để xong.
- **Giữ OK** (hoặc nút **Menu**) trên app ở trang Ứng dụng: mở menu để thêm hoặc bỏ yêu thích, ẩn app, hoặc xoá app khỏi TV.
- **Back**: quay lại trang trước.

### Trang Ứng dụng

Lưới tất cả app, có ô tìm kiếm theo tên. Thứ tự sắp theo số lần mở (mặc định) hoặc theo tên, đổi trong **Cài đặt › Chung**.

### Control Center

Bấm nút tròn ở góc trên bên phải để mở Control Center:

- **Wi-Fi**: xem mạng đang dùng, quét và chọn mạng khác, nhập mật khẩu bằng bàn phím trên TV.
- **Bluetooth**: tìm và kết nối loa, tai nghe.
- **Âm lượng**: Trái/Phải để tăng giảm, OK để tắt hoặc bật tiếng.
- **Đèn nền** và **chế độ hình**: Trái/Phải để chỉnh.
- **Tắt màn hình**: TV vẫn phát tiếng, bấm phím bất kỳ để bật lại màn hình.
- **Đầu vào** và **Cài đặt TV** (mở cài đặt gốc của LG).

### Tìm kiếm

Khi bạn tìm bằng giọng nói hoặc gõ chữ từ Nobi Remote, TV mở trang tìm kiếm: hàng trên cùng là kết quả của LG (video YouTube, phim), tiếp theo là app và đầu vào trùng tên. Chọn một kết quả để mở video hoặc app đó.

### Cài đặt

| Mục            | Có gì                                                                                                                                                                             |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Chung**      | Tên app, đồng hồ (12/24 giờ, hiện giây), giảm chuyển động, ngôn ngữ (Tiếng Việt, English), tên trong lời chào, cách sắp xếp app, màu nhấn (Sáng, Đỏ Oxblood, Xanh biển, Xanh lá). |
| **Hình nền**   | 5 hình nền có sẵn và các ảnh bạn gửi từ điện thoại.                                                                                                                               |
| **Thời tiết**  | Bật hoặc tắt widget, chọn thành phố, đơn vị °C hoặc °F.                                                                                                                           |
| **Đầu vào**    | Đổi tên từng đầu vào và chọn khi nào hiện trên dock: luôn hiện, không bao giờ, hoặc chỉ khi có thiết bị cắm vào.                                                                  |
| **Hệ thống**   | Làm mới danh sách app, kiểu hiển thị văn bản, thoát app, và **địa chỉ của Nobi Remote**.                                                                                          |
| **Tích hợp**   | 4 công tắc ở [phần trên](#bật-tích-hợp-hệ-thống).                                                                                                                                 |
| **Giới thiệu** | Phiên bản, tác giả, mã nguồn.                                                                                                                                                     |

## Nobi Remote: điều khiển từ điện thoại

Nobi Remote là trang web chạy ngay trên TV. Điện thoại chỉ cần trình duyệt, không cần cài app. Có thể thêm trang này ra màn hình chính để dùng như một app.

### Thiết lập lần đầu

1. Trên TV, bật **Cài đặt › Tích hợp › Điều khiển từ điện thoại (Nobi Remote)**.
2. Xem địa chỉ ở **Cài đặt › Hệ thống › Điều khiển từ điện thoại**, ví dụ `192.168.1.3:8766`.
3. Trên điện thoại (cùng Wi-Fi với TV), mở `http://<địa chỉ đó>`. Trang thiết lập của Nobi Remote hiện ra.
4. **Cài chứng chỉ của TV**, việc chỉ làm một lần. Nobi Remote chạy qua HTTPS bằng chứng chỉ do chính TV tạo ra. Cài chứng chỉ thì trình duyệt không còn cảnh báo, và điện thoại hiện đúng biểu tượng khi thêm ra màn hình chính.

   **iPhone**
   1. Mở trang thiết lập bằng **Safari** (Chrome không cài được hồ sơ).
   2. Bấm **Tải chứng chỉ (iPhone)** rồi chọn **Cho phép**.
   3. Vào **Cài đặt › Đã tải về hồ sơ › Cài đặt**.
   4. Vào **Cài đặt › Cài đặt chung › Giới thiệu › Cài đặt tin cậy chứng nhận**, bật **Nobi Home CA**.

   **Android**
   1. Bấm **Tải chứng chỉ (Android)**.
   2. Vào **Cài đặt › Bảo mật › Mã hoá và thông tin xác thực › Cài chứng chỉ CA** và chọn file vừa tải.

5. Bấm **Mở Nobi Remote**. Lần đầu, iPhone có thể hỏi quyền truy cập mạng cục bộ: bấm **Cho phép**.
6. **Ghép với TV**: bấm **Hiện mã trên TV**, TV hiện mã 4 số, nhập mã vào điện thoại rồi bấm **Ghép**. Điện thoại được ghi nhớ, lần sau không phải nhập lại.
7. Lần đầu bấm phím, TV hỏi có cho điện thoại điều khiển không: dùng remote của TV bấm **Cho phép**.
8. Thêm ra màn hình chính: trên iPhone, bấm **Chia sẻ › Thêm vào MH chính** trong Safari; trên Android, mở menu Chrome và chọn **Thêm vào màn hình chính**.

> [!TIP]
> Nên đặt IP cố định cho TV trong router (DHCP reservation). Khi IP của TV đổi, TV tự ký lại chứng chỉ và điện thoại vẫn tin chứng chỉ đó, nhưng biểu tượng trên màn hình chính vẫn trỏ vào địa chỉ cũ.

### Thanh trên cùng

- Trạng thái kết nối (**Đã kết nối** hoặc **Đang kết nối lại…**).
- Đồng hồ đếm ngược khi đang hẹn giờ tắt TV.
- Nút đổi giao diện sáng hoặc tối cho trang web.
- Nút **Nguồn**: tắt màn hình, bật lại màn hình, hoặc tắt TV.

Nền của trang web là hình nền đang dùng trên TV, làm mờ.

### Tab Điều khiển

- **Phím điều hướng** và **OK**. Giữ một phím mũi tên để bấm lặp liên tục.
- **Quay lại**, **Trang chủ**, **Phát hoặc tạm dừng**.
- **Âm lượng** tăng, giảm, tắt tiếng; số âm lượng cập nhật ngay.
- **Kênh** trước và sau.
- **Micro**: giữ nút micro, nói nội dung cần tìm rồi thả tay. TV mở trang tìm kiếm với kết quả YouTube và kết quả tìm kiếm của LG. Nếu trình duyệt không hỗ trợ nhận giọng nói, Nobi Remote hiện ô gõ chữ; bạn có thể đọc bằng micro của bàn phím điện thoại.
- **Gõ chữ lên TV**: gõ vào ô trên điện thoại, chữ xuất hiện trong ô nhập đang mở trên TV (ví dụ ô tìm kiếm của YouTube).
- **Cài đặt LG**: mở cài đặt gốc của TV.

### Tab Ứng dụng

- Ô **Tìm ứng dụng** theo tên.
- **Đầu vào**: Live TV, các cổng HDMI.
- **Yêu thích** và **Tất cả ứng dụng**: chạm để mở trên TV.

### Tab TV

- **Âm thanh · Hình ảnh**: thanh trượt âm lượng và đèn nền, chọn chế độ hình.
- **Wi-Fi**: quét và kết nối mạng, nhập mật khẩu ngay trên điện thoại.
- **Bluetooth**: tìm, kết nối hoặc ngắt loa, tai nghe.
- **Hẹn giờ tắt**: Tắt, 15, 30, 60, 90 hoặc 120 phút. Thời gian còn lại hiện ở thanh trên cùng.
- **Tắt màn hình**: tắt màn hình mà TV vẫn phát tiếng.
- **Điện thoại đã ghép**: xem và gỡ các điện thoại đã ghép. Điện thoại bị gỡ phải nhập mã PIN lại.

### Tab Launcher

Chỉnh Nobi Launcher trên TV mà không cần cầm remote:

- **Hình nền**: chọn hình nền; bấm **Từ điện thoại** để chọn ảnh trong máy, ảnh được cắt vừa khung 16:9 và gửi lên TV (TV giữ tối đa 12 ảnh). Bấm **Sửa** để sắp xếp thứ tự, ẩn hình nền có sẵn hoặc xoá ảnh của bạn.
- **Yêu thích**: thêm, bỏ và sắp xếp app trên dock.
- **Giao diện web**: Tự động, Sáng hoặc Tối cho chính trang Nobi Remote.
- **Đồng hồ**: 12/24 giờ, hiện giây, tên trong lời chào.
- **Thời tiết**: bật widget, tìm và chọn thành phố, °C hoặc °F.
- **Chung**: màu nhấn, cách sắp xếp app, hiện tên app ở Trang chủ và trang Ứng dụng, giảm chuyển động.
- **Ứng dụng được hiện**: chọn app nào hiện trên Nobi Launcher.

## Cập nhật

Cài file `.ipk` mới đè lên bản cũ theo [Bước 3](#bước-3-cài-file-ipk). Cài đặt, hình nền, ảnh và các điện thoại đã ghép đều được giữ nguyên. Sau khi cài, tắt và bật lại TV để Nobi Launcher và Nobi Remote chạy bản mới.

## Gỡ cài đặt

1. Vào **Cài đặt › Tích hợp**, tắt **Nút Home mở Nobi Launcher**, rồi chọn **Khởi động lại ngay**.
2. Mở lại Nobi Launcher, tắt 3 mục còn lại trong **Tích hợp**.
3. Gỡ app **Nobi Launcher** bằng trình quản lý app của LG hoặc webOS Dev Manager.
4. Trên điện thoại, gỡ hồ sơ **Nobi Home CA** nếu không dùng Nobi Remote nữa. Trên iPhone, hồ sơ nằm ở **Cài đặt › Cài đặt chung › VPN & Quản lý thiết bị**.

## Xử lý sự cố

**Bấm Home vẫn ra màn hình của LG.** Công tắc **Nút Home** chỉ có hiệu lực sau khi khởi động lại TV. Kiểm tra Quick Start+ đã tắt, rồi tắt hẳn TV và bật lại.

**Bật TV không thấy Nobi Launcher.** Nobi Launcher mở khoảng một phút sau khi TV khởi động. Nếu Quick Start+ đang bật, TV chỉ thức dậy chứ không khởi động lại, nên Nobi Launcher không tự mở.

**Trang Tích hợp báo cần root.** Homebrew Channel không chạy được lệnh bằng quyền root. Kiểm tra lại việc root trong app Homebrew Channel.

**Điện thoại không mở được Nobi Remote.**

- Kiểm tra công tắc **Điều khiển từ điện thoại** đang bật và điện thoại dùng cùng Wi-Fi với TV.
- Xem lại địa chỉ ở **Cài đặt › Hệ thống**, vì IP của TV có thể đã đổi.
- Trình duyệt báo chứng chỉ không an toàn: làm lại bước cài chứng chỉ, và trên iPhone nhớ bật **Nobi Home CA** trong **Cài đặt tin cậy chứng nhận**.

**Biểu tượng Nobi Remote trên màn hình chính iPhone chỉ là chữ N.** iPhone chưa tin chứng chỉ của TV lúc thêm biểu tượng. Bật **Nobi Home CA** như ở bước cài chứng chỉ, xoá biểu tượng cũ rồi thêm lại từ Safari.

**Phím trên điện thoại không có tác dụng.** Lần đầu, TV hỏi có cho điện thoại điều khiển không. Dùng remote của TV bấm **Cho phép**.

## Giấy phép và ghi công

- Nobi Launcher do Nobi Nhat Nguyen phát triển, phát hành theo giấy phép MIT (xem file `LICENSE` của repo).
- Dựa trên [lg-luma](https://github.com/ecklf/lg-luma) của ecklf (MIT).
- Font Inter (SIL Open Font License 1.1), biểu tượng con giáp từ Fluent Emoji của Microsoft (MIT), SDL (zlib).
- Mã nguồn: [github.com/nobinhatnguyen/webos-faultmanager-auto](https://github.com/nobinhatnguyen/webos-faultmanager-auto).
