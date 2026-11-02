# Quy ước repo webos-faultmanager-auto

Repo **public** trên GitHub (`nobinhatnguyen/webos-faultmanager-auto`), người dùng tải ZIP về và mở `README.html`. Vì vậy mọi thay đổi đưa lên GitHub phải truy được theo phiên bản.

## Quy tắc bắt buộc: mỗi lần push = một phiên bản

Trước **mỗi lần `git push`** (kể cả sửa chữ nhỏ), làm đủ 4 bước sau trong cùng commit/đợt push:

> **Một số chung với Nobi Launcher** (user chốt 02/11/2026, từ v1.1.1): `VERSION` luôn trùng `version` trong `webos-remake/git-code/package.json`, và file cài luôn là `nobi-launcher/com.nobi.launcher_<VERSION>_arm.ipk`. Push repo này mà chỉ sửa hướng dẫn hay tvopt vẫn phải tăng số ở cả hai bên: tăng version Launcher (`pnpm version:sync`, thêm mục `release/CHANGELOG.md`), build lại gói, chép gói, `SHA256SUMS` và `CHANGELOG.md` sang đây, xoá gói cũ. Ngược lại, mỗi bản Launcher mới cũng là một bản mới của repo này. **Trước khi push**, gói mới phải được cài lên TV thử và chạy đúng (user chốt 02/11/2026).

1. **Tăng số phiên bản** trong file [`VERSION`](./VERSION) theo SemVer `MAJOR.MINOR.PATCH` (cùng số với Nobi Launcher):
   - `PATCH` (1.0.0 → 1.0.1): sửa lỗi chính tả, câu chữ, link, lệnh sai.
   - `MINOR` (1.0.1 → 1.1.0): thêm mục hướng dẫn, thêm script/tính năng, cập nhật gói Nobi Launcher hoặc tvopt.
   - `MAJOR` (1.1.0 → 2.0.0): đổi cấu trúc repo, đổi quy trình root, bỏ/đổi tên file mà người dùng đang dùng.
2. **Ghi changelog ngắn gọn** (1–4 gạch đầu dòng, viết cho người dùng cuối, không liệt kê chi tiết kỹ thuật) vào **cả hai** file ở gốc repo, mục mới nằm **trên cùng**:
   - `README.md` → mục `## Lịch sử phiên bản`, dạng `### vX.Y.Z — YYYY-MM-DD`.
   - `README.html` → section `id="wrap-section-changelog"`, thêm một khối `<h3>vX.Y.Z — YYYY-MM-DD</h3><ul>…</ul>` mới ở đầu.
   - Cập nhật luôn dòng **Phiên bản hiện tại** ở đầu `README.md`, trong section changelog của `README.html` và chip `Phiên bản vX.Y.Z` trong `hero-meta` ở đầu `README.html`.
3. **Commit** với message bắt đầu bằng phiên bản, ví dụ `v1.0.1: Fix tvopt install command for Windows`.
4. **Gắn tag và push kèm tag:**

   ```bash
   git tag -a vX.Y.Z -m "vX.Y.Z"
   git push --follow-tags
   ```

Kiểm tra nhanh trước khi push: số trong `VERSION`, dòng "Phiên bản hiện tại" ở `README.md`, mục mới nhất trong cả hai README, tag sắp tạo và tên file `.ipk` phải **trùng nhau**.

```bash
v=$(cat VERSION); grep -c "v$v" README.md README.html; ls nobi-launcher/com.nobi.launcher_${v}_arm.ipk
grep '"version"' ../webos-remake/git-code/package.json
```

`README.md` phải ra ít nhất `2` (dòng phiên bản hiện tại + mục changelog), `README.html` ít nhất `3` (thêm chip ở hero).

## Ghi chú khác

- `README.md` và `README.html` là hai bản của cùng một nội dung: sửa nội dung ở file này thì sửa tương ứng ở file kia.
- Thư mục con `nobi-launcher/`, `tv-optimize/` có README riêng. Gói Nobi Launcher dùng chung số với repo (xem đầu mục quy tắc); trong `nobi-launcher/README.html` nhớ đổi cả chip "Phiên bản" ở hero và dung lượng gói.
