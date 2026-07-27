# Device-specific recovery additions.
# Keep the common MTK/TWRP defaults in BoardConfig.mk until stock images
# establish the exact boot/vendor_boot header and partition geometry.

TW_THEME := portrait_hdpi
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_USE_TOOLBOX := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_FUSE_EXFAT := true
TW_NO_REBOOT_BOOTLOADER := false
TW_NO_REBOOT_RECOVERY := false

# Find X9 uses an MT6993 / 6.12 GKI-derived kernel. The actual recovery
# kernel should be supplied from a matching stock boot/vendor_boot image or
# built from the corresponding kernel branch.
TARGET_KERNEL_VERSION := 6.12
