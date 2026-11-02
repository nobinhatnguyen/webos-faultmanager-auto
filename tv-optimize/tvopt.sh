#!/bin/sh
# tvopt — tối ưu TV LG webOS đã root (Homebrew Channel). Một file, chạy thẳng trên TV bằng root.
#
#   sh tvopt.sh install     cài vào /home/root/tvopt + hook khởi động, áp dụng ngay
#   sh tvopt.sh status      xem trạng thái từng mục tối ưu + RAM
#   sh tvopt.sh apply       áp dụng một lượt ngay (không chờ, không lặp)
#   sh tvopt.sh uninstall [--telnet]   gỡ hook, bỏ chặn quảng cáo; --telnet bật lại telnet
#   sh tvopt.sh run         vòng chạy nền lúc khởi động (hook gọi, không cần gọi tay)
#
# Không sửa phân vùng hệ thống: hosts là bind mount trong RAM, dịch vụ chỉ bị tắt tới lần
# khởi động sau → gỡ hook rồi khởi động lại là TV trở về như cũ. Đã thử: webOS TV Lite 4.4.3.
DIR=/home/root/tvopt
CONF=$DIR/tvopt.conf
HOOK=/var/lib/webosbrew/init.d/90tvopt
PREFS=/var/luna/preferences
LOG=/tmp/tvopt.log
MARK='# tvopt'

# Mặc định; tvopt.conf ghi đè. Sửa conf rồi `tvopt.sh apply` hoặc khởi động lại.
BLOCK_ADS=1
BLOCK_TELEMETRY=0
BLOCK_UPDATES=1
DISABLE_TELNET=1
DISABLE_AIRPLAY=1
CLOSE_PRELOADED=1
PRELOADED_APPS="netflix youtube.leanback.v4"
BOOT_DELAY=90
INTERVAL=900
[ -f "$CONF" ] && . "$CONF"

# Quảng cáo trên Home/Content Store. KHÔNG thêm snu.lge.com (Homebrew đã chặn khi bật
# block updates), lgtvsdp.com, lgappstv.com, nextlgsdp.com, lgsmartweb.com: hỏng Content Store,
# đăng nhập, tìm kiếm giọng nói.
ADS_HOSTS="ad.lgappstv.com lgad.cjpowercast.com ad.lgsmartad.com info.lgsmartad.com
us.ad.lgsmartad.com eu.ad.lgsmartad.com ap.ad.lgsmartad.com us.info.lgsmartad.com
eu.info.lgsmartad.com ap.info.lgsmartad.com smartclip.net smartclip.com yumenetworks.com"
# Báo lỗi/thống kê (crash, analytics). Cộng đồng báo không hỏng gì; chưa thử trên webOS 4.
TELEMETRY_HOSTS="rdx2.lgtvsdp.com rdx2.nextlgsdp.com rdl.lgtvcommon.com"

log() { echo "$(date '+%H:%M:%S') $*" | tee -a "$LOG"; }

# Có máy `luna-send -n 1` không in kết quả khi stdout là pipe → dùng -i rồi tự ngắt.
lc() {
  luna-send -i "$1" "$2" > /tmp/tvopt.lc 2>&1 & p=$!
  sleep 3; kill "$p" 2>/dev/null; cat /tmp/tvopt.lc
}

foreground() { lc luna://com.webos.applicationManager/getForegroundAppInfo '{}' | grep -o '"appId":"[^"]*"' | head -1 | cut -d'"' -f4; }

# App đang giữ bộ giải mã video (vd. YouTube phát sau Launcher dạng overlay) — không đóng.
playing() {
  command -v node >/dev/null || return 0
  lc luna://com.webos.media/getActivePipelines '{}' | node -e '
var s = "";
process.stdin.on("data", function (d) { s += d; });
process.stdin.on("end", function () {
  var a;
  try { a = JSON.parse(s.slice(s.indexOf("["), s.lastIndexOf("]") + 1)); } catch (e) { return; }
  a.forEach(function (p) {
    if ((p.resource || []).some(function (r) { return r.resource === "VDEC"; })) console.log(p.currentAppId);
  });
});' 2>/dev/null
}

hosts_add() {  # $1 = nhóm, các tham số còn lại = tên miền
  group=$1; shift; n=0
  # Homebrew Channel (block updates) đã bind /tmp/hosts lên /etc/hosts; chưa thì tự làm.
  if ! grep -q ' /etc/hosts ' /proc/mounts; then
    cp /etc/hosts /tmp/hosts && mount --bind /tmp/hosts /etc/hosts
  fi
  for h in "$@"; do
    grep -q "[[:space:]]$h\([[:space:]]\|\$\)" /etc/hosts && continue
    echo "0.0.0.0 $h $MARK" >> /etc/hosts; n=$((n + 1))
  done
  log "chặn $group: thêm $n tên miền"
}

# Ghi đè nội dung (không sed -i: đổi tên file đè lên bind mount sẽ lỗi).
hosts_clear() {
  grep -q "$MARK" /etc/hosts || return 0
  grep -v "$MARK" /etc/hosts > /tmp/tvopt.hosts && cat /tmp/tvopt.hosts > /etc/hosts
}

stop_airplay() {
  pidof airplay homekit >/dev/null || { log "AirPlay/HomeKit không chạy"; return; }
  command -v stop >/dev/null && stop airplay-adaptor >/dev/null 2>&1
  lc luna://com.webos.applicationManager/closeByAppId '{"id":"airplay"}' >/dev/null
  killall airplay 2>/dev/null
  killall -9 homekit 2>/dev/null   # bỏ qua SIGTERM; dịch vụ Luna động, có lệnh gọi tới thì tự bật lại
  log "đã tắt AirPlay/HomeKit"
}

# Đóng app nạp sẵn ở nền (YouTube, Netflix…); bỏ qua app đang hiển thị hoặc đang phát video.
close_preloaded() {
  keep="$(foreground) $(playing)"
  for app in $PRELOADED_APPS; do
    case " $keep " in *" $app "*) continue ;; esac
    lc luna://com.webos.applicationManager/running '{}' | grep -q "\"id\":\"$app\"" || continue
    # Mỗi lc mất 3 s: đọc lại ngay trước khi đóng, kẻo user vừa mở app đó.
    [ "$app" = "$(foreground)" ] && continue
    lc luna://com.webos.applicationManager/closeByAppId "{\"id\":\"$app\"}" >/dev/null
    log "đóng $app (nền)"
  done
}

flag() {  # $1 = tên cờ Homebrew Channel, $2 = 1 bật / 0 tắt
  if [ "$2" = 1 ]; then touch "$PREFS/$1"; else rm -f "$PREFS/$1"; fi
}

apply_flags() {
  flag webosbrew_telnet_disabled "$DISABLE_TELNET"
  [ "$DISABLE_TELNET" = 1 ] && killall telnetd 2>/dev/null && log "đã đóng telnet root (cổng 23)"
  # Homebrew Channel đọc cờ này lúc khởi động; có hiệu lực từ lần khởi động sau.
  flag webosbrew_block_updates "$BLOCK_UPDATES"
}

apply_hosts() {
  hosts_clear
  [ "$BLOCK_ADS" = 1 ] && hosts_add "quảng cáo" $ADS_HOSTS $(grep -v '^#' "$DIR/ads-hosts.txt" 2>/dev/null)
  [ "$BLOCK_TELEMETRY" = 1 ] && hosts_add "telemetry" $TELEMETRY_HOSTS
  return 0
}

apply_now() {
  apply_flags
  apply_hosts
  [ "$DISABLE_AIRPLAY" = 1 ] && stop_airplay
  [ "$CLOSE_PRELOADED" = 1 ] && close_preloaded
  return 0
}

run_boot() {
  log "bắt đầu (khởi động)"
  apply_hosts
  sleep "${BOOT_DELAY:-90}"
  [ "$DISABLE_AIRPLAY" = 1 ] && stop_airplay
  [ "$CLOSE_PRELOADED" = 1 ] || exit 0
  while :; do
    close_preloaded
    [ "${INTERVAL:-0}" -gt 0 ] || break
    sleep "$INTERVAL"
  done
}

write_conf() {
  [ -f "$CONF" ] && { echo "Giữ cấu hình cũ: $CONF"; return; }
  cat > "$CONF" <<EOF
# Cấu hình tvopt. Sửa xong: sh $DIR/tvopt.sh apply (hoặc khởi động lại TV). 1 = bật, 0 = tắt.
BLOCK_ADS=1          # chặn tên miền quảng cáo LG (thêm tên miền riêng vào $DIR/ads-hosts.txt)
BLOCK_TELEMETRY=0    # chặn thêm tên miền báo lỗi/thống kê (chưa thử trên webOS 4)
BLOCK_UPDATES=1      # chặn cập nhật firmware (giữ root), cùng công tắc trong Homebrew Channel
DISABLE_TELNET=1     # tắt telnet root không mật khẩu ở cổng 23 (nên tắt; SSH vẫn dùng được)
DISABLE_AIRPLAY=1    # đặt 0 nếu dùng iPhone/Mac chiếu lên TV
CLOSE_PRELOADED=1    # đóng app nạp sẵn ở nền
PRELOADED_APPS="netflix youtube.leanback.v4"
BOOT_DELAY=90        # giây chờ sau khi khởi động
INTERVAL=900         # kiểm lại mỗi 15 phút (0 = chỉ lúc khởi động); app đang xem không bị đóng
EOF
}

install() {
  mkdir -p "$DIR"
  [ "$(cd "$(dirname "$0")" && pwd)/$(basename "$0")" = "$DIR/tvopt.sh" ] || cp "$0" "$DIR/tvopt.sh"
  chmod 755 "$DIR/tvopt.sh"
  write_conf
  . "$CONF"
  printf '#!/bin/sh\n%s/tvopt.sh run </dev/null >/dev/null 2>&1 &\n' "$DIR" > "$HOOK"
  chmod 755 "$HOOK"
  echo "Đã cài hook $HOOK. Áp dụng ngay (mất khoảng 10–20 giây)…"
  apply_now
  echo "Xong. Xem lại: sh $DIR/tvopt.sh status"
}

uninstall() {
  rm -f "$HOOK"
  hosts_clear
  [ "$1" = --telnet ] && flag webosbrew_telnet_disabled 0 && echo "Telnet bật lại từ lần khởi động sau."
  rm -rf "$DIR"
  echo "Đã gỡ tvopt. Khởi động lại TV để AirPlay và app nạp sẵn chạy lại như cũ."
  echo "Chặn cập nhật firmware vẫn giữ; bỏ trong Settings của Homebrew Channel nếu muốn."
}

onoff() { if [ -e "$1" ]; then echo "$2"; else echo "$3"; fi; }

status() {
  ver=$(grep -o '"webos_release":"[^"]*"' /var/run/nyx/os_info.json 2>/dev/null | cut -d'"' -f4)
  echo "webOS:            ${ver:-không rõ}"
  echo "Hook khởi động:   $(onoff "$HOOK" 'đã cài' 'chưa cài')"
  echo "Telnet root:      $(onoff "$PREFS/webosbrew_telnet_disabled" 'tắt' 'BẬT (cổng 23 không mật khẩu)')"
  echo "Chặn cập nhật:    $(onoff "$PREFS/webosbrew_block_updates" 'bật' 'tắt')"
  echo "Tên miền đã chặn: $(grep -c "$MARK" /etc/hosts)"
  echo "AirPlay/HomeKit:  $(pidof airplay homekit >/dev/null && echo 'đang chạy' || echo 'không chạy')"
  echo "App đang chạy:    $(lc luna://com.webos.applicationManager/running '{}' | grep -o '"id":"[^"]*"' | cut -d'"' -f4 | tr '\n' ' ')"
  awk '/MemTotal|MemAvailable|SwapTotal|SwapFree/ {printf "%-17s %d MB\n", $1, $2 / 1024}' /proc/meminfo
  [ -f "$LOG" ] && { echo "--- $LOG"; tail -n 8 "$LOG"; }
}

[ "$(id -u)" = 0 ] || { echo "Cần chạy bằng root (TV đã root qua Homebrew Channel)." >&2; exit 1; }
[ -d /var/lib/webosbrew ] || { echo "Không thấy Homebrew Channel (/var/lib/webosbrew)." >&2; exit 1; }

case "$1" in
  install) install ;;
  uninstall) uninstall "$2" ;;
  status) status ;;
  apply) apply_now ;;
  run) run_boot ;;
  *) sed -n '2,8p' "$0" | cut -c3-; exit 1 ;;
esac
