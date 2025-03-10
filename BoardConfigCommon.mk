#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/motorola/mt6768-common
KERNEL_PATH := device/motorola/mt6768-kernel

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a75

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

# Display
TARGET_SCREEN_DENSITY := 280

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/mediatek/vintf/mediatek_framework_compatibility_matrix.xml \

DEVICE_MANIFEST_FILE += $(COMMON_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(COMMON_PATH)/compatibility_matrix.xml

# Kernel
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_KERNEL_PAGESIZE := 0x00001000
BOARD_TAGS_OFFSET := 0x0bc08000
BOARD_RAMDISK_OFFSET := 0x07c08000
BOARD_KERNEL_CMDLINE += bootopt=64S3,32N2,64N2

BOARD_RAMDISK_USE_LZ4 := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_USES_GENERIC_KERNEL_IMAGE := true

BOARD_MKBOOTIMG_ARGS += \
    --dtb_offset $(BOARD_TAGS_OFFSET) \
    --header_version $(BOARD_BOOT_HEADER_VERSION) \
    --kernel_offset $(BOARD_KERNEL_OFFSET) \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset $(BOARD_TAGS_OFFSET)

TARGET_NO_KERNEL_OVERRIDE := true
TARGET_KERNEL_SOURCE := device/motorola/mt6768-kernel/kernel-headers

LOCAL_KERNEL := $(KERNEL_PATH)/$(BOARD_KERNEL_IMAGE_NAME)
PRODUCT_COPY_FILES += \
	$(LOCAL_KERNEL):kernel

# Properties
TARGET_SYSTEM_PROP += $(COMMON_PATH)/system.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/vendor.prop

## vendor_boot modules
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD += $(strip $(shell cat $(COMMON_PATH)/modules.load.common.vendor_boot))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += $(addprefix $(KERNEL_PATH)/common_vendor_boot-modules/, $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD))

## recovery modules
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD += $(strip $(shell cat $(COMMON_PATH)/modules.load.common.recovery))
RECOVERY_MODULES += $(addprefix $(KERNEL_PATH)/common_vendor_boot-modules/, $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD))

## Prevent duplicated entries (to solve duplicated build rules problem)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += $(sort $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES) $(RECOVERY_MODULES))

## vendor modules
BOARD_VENDOR_KERNEL_MODULES_LOAD += $(strip $(shell cat $(COMMON_PATH)/modules.load.common.vendor))
BOARD_VENDOR_KERNEL_MODULES += $(wildcard $(KERNEL_PATH)/common_vendor-modules/*.ko)

# Partitions
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot 
    
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864

BOARD_DYNAMIC_PARTITIONS_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := $(BOARD_DYNAMIC_PARTITIONS_FILE_SYSTEM_TYPE)
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := $(BOARD_DYNAMIC_PARTITIONS_FILE_SYSTEM_TYPE)
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := $(BOARD_DYNAMIC_PARTITIONS_FILE_SYSTEM_TYPE)
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := $(BOARD_DYNAMIC_PARTITIONS_FILE_SYSTEM_TYPE)
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

TARGET_COPY_OUT_SYSTEM := system
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product

BOARD_SUPER_PARTITION_SIZE := 8589934592
BOARD_SUPER_PARTITION_GROUPS := motorola_dynamic_partitions
BOARD_MOTOROLA_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext vendor product
BOARD_MOTOROLA_DYNAMIC_PARTITIONS_SIZE := 8585740288

BOARD_USES_METADATA_PARTITION := true

## Disable sparse for ext/f2fs images
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
TARGET_USERIMAGES_SPARSE_F2FS_DISABLED := true

# Platform
BOARD_HAS_MTK_HARDWARE := true
BOARD_HAVE_MTK_FM := true

# SKU
ODM_MANIFEST_SKUS += ss tsts qsqs dsds
ODM_MANIFEST_SS_FILES := $(COMMON_PATH)/manifest_ss.xml
ODM_MANIFEST_TSTS_FILES := $(COMMON_PATH)/manifest_tsts.xml
ODM_MANIFEST_QSQS_FILES := $(COMMON_PATH)/manifest_qsqs.xml
ODM_MANIFEST_DSDS_FILES := $(COMMON_PATH)/manifest_dsds.xml

# Recovery
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab.mt6768
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165
TARGET_USERIMAGES_USE_F2FS := true

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Inherit the proprietary files
include vendor/motorola/mt6768-common/BoardConfigVendor.mk
