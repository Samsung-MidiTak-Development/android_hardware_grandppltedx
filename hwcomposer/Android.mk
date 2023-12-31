LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ifeq ($(MTK_HWC_SUPPORT), yes)

ifneq ($(findstring 2., $(MTK_HWC_VERSION)),)
LOCAL_SRC_FILES := \
	hwc2_api.cpp
else
LOCAL_SRC_FILES := \
	hwc.cpp
endif

LOCAL_CFLAGS := \
	-DLOG_TAG=\"hwcomposer\"

ifeq ($(MTK_HDMI_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_EXTERNAL_SUPPORT
endif

ifeq ($(MTK_WFD_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_VIRTUAL_SUPPORT
endif

ifeq ($(TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS), true)
LOCAL_CFLAGS += -DMTK_FORCE_HWC_COPY_VDS
endif

ifeq ($(TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK), true)
LOCAL_CFLAGS += -DMTK_WITHOUT_PRIMARY_PRESENT_FENCE
endif

ifneq ($(MTK_BASIC_PACKAGE), yes)
ifneq ($(MTK_ADJUST_VSYNC_OFFSET_ACTIVELY), no)
ifneq ($(MTK_MERGE_MDP_DISPLAY), no)
LOCAL_CFLAGS += -DMTK_MERGE_MDP_DISPLAY
endif
endif
endif

# 0:MHL/HDMI  1:EPAPER  2:LCD
ifneq ($(MTK_DUAL_DISPLAY), )
LOCAL_CFLAGS += -DMTK_DUAL_DISPLAY=$(MTK_DUAL_DISPLAY)
else
LOCAL_CFLAGS += -DMTK_DUAL_DISPLAY=0
endif

ifeq ($(MTK_DUAL_DISPLAY), 1)
ifneq ($(MTK_EPAPER_VENDOR),)
LOCAL_CFLAGS += -DMTK_EPAPER_VENDOR=\"$(MTK_EPAPER_VENDOR)\"
else
LOCAL_CFLAGS += -DMTK_EPAPER_VENDOR=\"dummy\"
endif
else
LOCAL_CFLAGS += -DMTK_EPAPER_VENDOR=NULL
endif

ifneq ($(MTK_ADJUST_VSYNC_OFFSET_ACTIVELY), no)
ifneq ($(MTK_MERGE_MDP_DISPLAY), no)
ifneq ($(MTK_BASIC_PACKAGE), yes)
LOCAL_CFLAGS += -DMTK_MERGE_MDP_DISPLAY
endif
endif
endif

ifneq ($(findstring 1.2, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_1_2
endif

ifneq ($(findstring 1.3, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_1_3
endif

ifneq ($(findstring 1.4, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_1_4
endif

ifneq ($(findstring 1.5, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_1_5
endif

ifneq ($(findstring 2.0, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_2_0
LOCAL_CFLAGS += -USE_HWC2
endif



LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/include

LOCAL_STATIC_LIBRARIES += \
	hwcomposer.$(TARGET_BOARD_PLATFORM).2.0.0

LOCAL_SHARED_LIBRARIES := \
	libui \
	libutils \
	libcutils \
	liblog \
	libsync \
	libion \
	libbwc \
	libion_mtk \
	libdpframework \
	libhardware \
	libgralloc_extra \
	libdl \
	libbinder \
	libpower

ifeq ($(MTK_M4U_SUPPORT), yes)
	LOCAL_SHARED_LIBRARIES += libm4u
endif

ifeq ($(MTK_DUAL_DISPLAY), 1)
ifneq ($(MTK_EPAPER_VENDOR),)
LOCAL_SHARED_LIBRARIES += \
	libtcon_$(MTK_EPAPER_VENDOR)
else
LOCAL_SHARED_LIBRARIES += \
	libtcon_dummy
endif
endif

ifeq ($(MTK_SEC_VIDEO_PATH_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_SVP_SUPPORT
endif # MTK_SEC_VIDEO_PATH_SUPPORT

ifneq ($(filter 1.4.0 1.4.0 1.4.0.sp 1.4.1 1.5.0 2.0.0,$(MTK_HWC_VERSION)),)
LOCAL_SHARED_LIBRARIES += \
	libged
endif

# HAL module implemenation stored in
# hw/<OVERLAY_HARDWARE_MODULE_ID>.<ro.product.board>.so
LOCAL_MODULE := hwcomposer.$(TARGET_BOARD_PLATFORM)
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := mtk

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MULTILIB := first
include $(BUILD_STATIC_LIBRARY)

endif # MTK_HWC_SUPPORT
