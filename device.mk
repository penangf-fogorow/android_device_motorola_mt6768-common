#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Add vendor log tags
include $(COMMON_PATH)/vendor_log_tags.mk

# Inherit the proprietary files
$(call inherit-product, vendor/motorola/mt6768-common/mt6768-common-vendor.mk)