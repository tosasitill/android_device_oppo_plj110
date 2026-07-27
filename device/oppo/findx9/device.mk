LOCAL_PATH := $(call my-dir)

# Recovery fstab is placed in the recovery root. The stock first-stage fstab
# is kept as a reference in extracted_findx9/vendor_ramdisk/.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery.fstab:$(TARGET_RECOVERY_ROOT_OUT)/etc/recovery.fstab
