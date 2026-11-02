# tvopt — tối ưu TV LG webOS

Bớt quảng cáo, bớt dịch vụ chạy ngầm, trả lại RAM cho TV LG webOS. Gồm hai phần:

- **Phần A — không cần root:** chỉnh trong Cài đặt của TV bằng remote. Ai cũng làm được.
- **Phần B — TV đã root:** script `tvopt.sh`, một file chạy thẳng trên TV.

Nên làm trước khi cài [Nobi Launcher](../nobi-launcher/README.md). Bản đọc bằng trình duyệt, có ô nhập IP để tự tạo lệnh: [`README.html`](./README.html).

Đã thử trên **55UK6340PTF, webOS TV Lite 4.4.3** (firmware 05.50.70). Với TV này, RAM khả dụng sau khi bật tăng từ khoảng 145 MB lên 340 MB. Máy webOS khác chạy được nhưng chưa thử; xem mục [Giới hạn](#giới-hạn).

## Phần A — không cần root

Mở **Settings → All Settings**. Tên mục có thể khác chút tuỳ vùng và phiên bản.

| # | Việc | Đường dẫn | Tác dụng |
|---|---|---|---|
| 1 | Tắt **Quick Start+** | General → Quick Start+ | Mỗi lần tắt/bật là khởi động lại thật, RAM được dọn sạch. Đổi lại bật lên chậm hơn 10–20 giây |
| 2 | Tắt **Home Auto Launch** | General → Home Settings | Bật TV không tự mở thanh Home |
| 3 | Tắt **Home Promotion**, **Content Recommendation** | General → Home Settings | Bỏ quảng cáo, đề xuất trên Home |
| 4 | Bỏ đồng ý **Viewing Information**, **Interest-Based Advertising**, **Voice Information** | General → About this TV → User Agreements | Ngừng quảng cáo theo hành vi, ngừng gửi dữ liệu xem |
| 5 | Tắt **Live Plus** | General → Live Plus | Ngừng nhận diện nội dung đang chiếu (ACR) |
| 6 | Tắt **AirPlay** nếu không chiếu từ iPhone/Mac | Home Dashboard → AirPlay & HomeKit Settings | Giải phóng khoảng 29 MB |
| 7 | Tắt **Mobile TV On** / **Turn on via Wi-Fi** | General → Mobile TV On | Bớt dịch vụ chờ đánh thức qua mạng |
| 8 | Đổi **DNS** sang DNS chặn quảng cáo, ví dụ AdGuard `94.140.14.14` | Network → Wi-Fi → Advanced Settings → Edit | Chặn quảng cáo ở mức mạng. Đặt trên router hoặc Pi-hole thì áp cho cả nhà |
| 9 | Tắt **Allow Automatic Updates** | General → About this TV | Giữ firmware hiện tại; bản mới có thể vá lỗ hổng dùng để root |
| 10 | Đóng app sau khi xem | Giữ nút Home → vuốt app lên | Netflix, YouTube không chiếm RAM ở nền |

Dùng Pi-hole hoặc router để chặn thì lấy danh sách tên miền trong biến `ADS_HOSTS` của `tvopt.sh`.

## Phần B — TV đã root

### Cần có

- TV đã root, có **Homebrew Channel** chạy ở chế độ root. Cách root: xem [hướng dẫn root](../README.md) trong repo này, hoặc [rootmy.tv](https://rootmy.tv) và [webosbrew.org](https://www.webosbrew.org). README này không hướng dẫn root.
- Vào được shell root: bật **SSH Server** trong Settings của Homebrew Channel (`ssh root@<IP-TV>`), hoặc telnet (cổng 23) nếu chưa bật SSH.

### Cài

Từ máy tính, trong thư mục chứa `tvopt.sh` (thay `192.168.1.100` bằng IP của TV). Lệnh chép bỏ ký tự xuống dòng kiểu Windows (CRLF), nên dùng được cả khi file bị đổi định dạng trên Windows.

macOS / Linux:

```bash
ssh root@192.168.1.100 "tr -d '\r' > /tmp/tvopt.sh" < tvopt.sh
```

Windows PowerShell (PowerShell không có toán tử `<`, nên chuyển file qua `cmd /c`):

```powershell
cmd /c "ssh root@192.168.1.100 `"tr -d '\r' > /tmp/tvopt.sh`" < tvopt.sh"
```

Cài và áp dụng:

```bash
ssh root@192.168.1.100 sh /tmp/tvopt.sh install
```

Kiểm tra:

```bash
ssh root@192.168.1.100 sh /home/root/tvopt/tvopt.sh status
```

Lệnh `install` chép script vào `/home/root/tvopt/`, tạo `tvopt.conf`, tạo hook khởi động `/var/lib/webosbrew/init.d/90tvopt` và áp dụng ngay (mất 10–20 giây). Từ lần bật TV sau, script tự chạy. Cài lại thì cấu hình cũ được giữ.

Không có máy tính có `ssh`: mở shell root trên TV, dán nội dung file vào `/tmp/tvopt.sh` (ví dụ `cat > /tmp/tvopt.sh`, dán, rồi Ctrl-D), sau đó chạy `sh /tmp/tvopt.sh install`.

### Các lệnh

| Lệnh (chạy trên TV) | Làm gì |
|---|---|
| `sh /home/root/tvopt/tvopt.sh status` | Xem từng mục đang bật/tắt, app đang chạy, RAM, 8 dòng log cuối |
| `sh /home/root/tvopt/tvopt.sh apply` | Áp dụng lại ngay sau khi sửa `tvopt.conf` |
| `sh /home/root/tvopt/tvopt.sh uninstall` | Gỡ hook, bỏ chặn quảng cáo, xoá `/home/root/tvopt`. Thêm `--telnet` để bật lại telnet |
| `cat /tmp/tvopt.log` | Log của lần khởi động này |

### Script làm gì

Mỗi mục bật/tắt trong `/home/root/tvopt/tvopt.conf` (`1` = bật, `0` = tắt):

| Biến | Mặc định | Làm gì | Lệnh tương đương nếu làm tay |
|---|---|---|---|
| `BLOCK_ADS` | 1 | Chặn 13 tên miền quảng cáo LG; thêm tên miền riêng vào `/home/root/tvopt/ads-hosts.txt`, mỗi dòng một tên | `cp /etc/hosts /tmp/hosts && mount --bind /tmp/hosts /etc/hosts` rồi thêm `0.0.0.0 ad.lgsmartad.com` … vào `/etc/hosts` |
| `BLOCK_TELEMETRY` | 0 | Chặn thêm 3 tên miền báo lỗi/thống kê. Chưa thử trên webOS 4 | Như trên với `rdx2.lgtvsdp.com`, `rdx2.nextlgsdp.com`, `rdl.lgtvcommon.com` |
| `BLOCK_UPDATES` | 1 | Chặn cập nhật firmware để giữ root. Là công tắc "Block system updates" của Homebrew Channel, có hiệu lực từ lần khởi động sau | `touch /var/luna/preferences/webosbrew_block_updates` |
| `DISABLE_TELNET` | 1 | Tắt telnet root **không mật khẩu** ở cổng 23 (ai trong mạng LAN cũng vào được). SSH vẫn dùng bình thường | `touch /var/luna/preferences/webosbrew_telnet_disabled; killall telnetd` |
| `DISABLE_AIRPLAY` | 1 | Tắt AirPlay và HomeKit tới lần khởi động sau. Đặt `0` nếu chiếu từ iPhone/Mac | `stop airplay-adaptor; luna-send -n 1 luna://com.webos.applicationManager/closeByAppId '{"id":"airplay"}'; killall airplay; killall -9 homekit` |
| `CLOSE_PRELOADED` | 1 | Đóng app LG nạp sẵn ở nền (`PRELOADED_APPS`), 90 giây sau khi bật rồi kiểm lại mỗi 15 phút. Không đóng app đang hiển thị hoặc đang phát video | `luna-send -n 1 luna://com.webos.applicationManager/closeByAppId '{"id":"netflix"}'` |
| `PRELOADED_APPS` | `netflix youtube.leanback.v4` | Danh sách app id cần đóng. Xem app id đang chạy bằng lệnh `status` | — |
| `BOOT_DELAY` | 90 | Số giây chờ sau khi bật TV rồi mới tắt AirPlay, đóng app | — |
| `INTERVAL` | 900 | Số giây giữa hai lần kiểm app nạp sẵn; `0` = chỉ kiểm lúc bật TV | — |

Các lệnh đọc trạng thái mà script dùng, có thể chạy tay để kiểm:

```bash
luna-send -n 1 luna://com.webos.applicationManager/running '{}'
```

```bash
luna-send -n 1 luna://com.webos.applicationManager/getForegroundAppInfo '{}'
```

```bash
luna-send -n 1 luna://com.webos.media/getActivePipelines '{}'
```

Trên một số TV, `luna-send -n 1` không in kết quả khi đầu ra đi qua pipe. Khi đó dùng `luna-send -i …` rồi bấm Ctrl-C; script đã tự xử lý việc này.

### An toàn và gỡ

- Script **không ghi vào phân vùng hệ thống**. `/etc/hosts` là bản trong RAM (bind mount); AirPlay và app nạp sẵn chỉ bị tắt tới lần khởi động sau. Gỡ hook rồi khởi động lại là TV trở về như cũ.
- Hook lỗi lúc khởi động thì chế độ failsafe của Homebrew Channel tự bỏ qua các hook ở lần sau.
- `uninstall` giữ nguyên cờ chặn cập nhật firmware; bỏ cờ này trong Settings của Homebrew Channel nếu muốn.

### Không nên chặn hoặc tắt

| Tên miền / dịch vụ | Chặn thì hỏng gì |
|---|---|
| `lgtvsdp.com`, `lgappstv.com`, `lgshopsvc.lgappstv.com` (trừ `ad.lgappstv.com`) | LG Content Store, cài và cập nhật app, đăng nhập |
| `nextlgsdp.com`, `lgsmartweb.com` | Tìm kiếm bằng giọng nói, kết quả tìm kiếm |
| `snu.lge.com`, `su.lge.com` | Không hỏng gì, nhưng Homebrew Channel đã tự chặn khi bật `BLOCK_UPDATES` |
| Tiến trình `sdx`, `prs` | Là dịch vụ Luna động: giết đi sẽ tự bật lại khi có lệnh gọi tới, không lợi gì |
| `surface-manager`, `tvservice`, `WebAppMgr` | Hệ thống; giết đi là TV treo hoặc khởi động lại |

## Giới hạn

- Chỉ thử trên webOS TV Lite 4.4.3. Máy webOS 5 trở lên dùng chung cách gọi Luna nhưng app id của YouTube, tên dịch vụ AirPlay có thể khác. Chạy `status` trước để xem app id thật, rồi sửa `PRELOADED_APPS`.
- Chặn bằng `/etc/hosts` không chặn được tên miền con tuỳ vùng (ví dụ `eic.`, `aic.`) hay IP ghi cứng trong firmware. Muốn chặn rộng hơn, dùng DNS hoặc Pi-hole như mục 8 của Phần A.
- Bỏ qua app đang phát video cần `node` trên TV (webOS có sẵn). Không có `node` thì script chỉ bỏ qua app đang hiển thị.

## Nguồn

- Cờ và hook của Homebrew Channel: [webosbrew/webos-homebrew-channel `services/startup.sh`](https://github.com/webosbrew/webos-homebrew-channel/blob/main/services/startup.sh).
- Nhóm tên miền và tác dụng phụ khi chặn: [Level1Techs — LG TV Block Mini-How-to](https://forum.level1techs.com/t/lg-tv-block-mini-how-to/255178), [hugobatista/lg-tv-ad-block](https://github.com/hugobatista/lg-tv-ad-block).
