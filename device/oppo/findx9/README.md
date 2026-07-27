# TWRP device tree — OPPO Find X9 (MT6993)

This is a first-pass TWRP/TeamWin device tree derived from the two local kernel trees:

- `android_kernel_modules_and_devicetree_oppo_mt6993`
- `oppo_mt6993`

The kernel source identifies the platform as `MT6993`, `k6993v1_64`, kernel `6.12`, and the Find X9 branch lists models `CPH2791`, `CPH2797`, `OPG07`, `PLG110`, `PLG120`, and `PLJ110`.

## Important

This tree is intentionally conservative. It supplies the Android build/TWRP integration layer, but it does not claim that a recovery image is boot-tested. The authoritative partition sizes, exact `vendor_boot` layout, AVB footer parameters, and encryption metadata must be checked against a matching stock `boot.img`, `vendor_boot.img`, `dtbo.img`, and `super` metadata dump before flashing.

## Layout

```text
device/oppo/findx9/
├── Android.bp
├── AndroidProducts.mk
├── BoardConfig.mk
├── device.mk
├── omni_findx9.mk
├── recovery.fstab
├── twrp.dependencies
├── configs/BoardConfigTwrp.mk
├── prebuilt/README.md
└── rootdir/etc/init.recovery.mt6993.rc
```

## 已提取的实机证据（PLJ110）

已通过 ADB 从当前设备 `PLJ110 / OP5E17L1` 的 `_b` 槽提取并解析：

```text
boot_b.img          64 MiB
vendor_boot_b.img   96 MiB
 dtbo_b.img         24 MiB
vbmeta_b.img         8 MiB
vbmeta_system_b.img  8 MiB
vbmeta_vendor_b.img  8 MiB
```

设备属性确认：

```text
ro.boot.hardware=mt6993
ro.boot.slot_suffix=_b
ro.build.version.release=16
ro.build.version.sdk=36
ro.crypto.metadata.enabled=true
ro.crypto.state=encrypted
```

`vendor_boot_b.img` 确认为 **vendor boot header version 4**，page size 为 `4096`。其中的 vendor ramdisk 为 LZ4 压缩的 cpio，已解包到：

```text
extracted_findx9/vendor_ramdisk/
```

实机 first-stage fstab 位于：

```text
extracted_findx9/vendor_ramdisk/first_stage_ramdisk/fstab.mt6993
```

它确认了：

- `system`、`system_ext`、`vendor`、`product`、`odm` 等为动态逻辑分区；
- 系统分区优先使用 EROFS；
- `metadata` 使用 F2FS；
- `userdata` 使用 F2FS + inlinecrypt + metadata encryption；
- 设备不存在独立 `recovery` by-name 分区；
- recovery 需要放入 `vendor_boot` 方案处理；
- vendor ramdisk 中存在 `modules.load.recovery`，说明 recovery 阶段会加载一组 MT6993/Oplus 内核模块。

`super.img` 已删除，未纳入后续制作流程。


```bash
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch omni_findx9-eng
mka recoveryimage
```

On Android 12+ devices using a vendor ramdisk, the resulting recovery may need to be packaged into `vendor_boot.img` rather than flashed as a standalone `recovery` partition. Use the stock image layout as the source of truth.
