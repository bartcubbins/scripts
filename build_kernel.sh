#!/bin/bash

start_time=$(date +%s)

#----------------------------------------------------------------------
# Arguments block
#----------------------------------------------------------------------
while [ $# -gt 0 ]; do
    case "$1" in
        -p | --platform)    PLATFORM_NAME="$2";;
        -d | --device)      DEVICE_NAME="$2";;
        -m | --menuconfig)  MENUCONFIG="true";;
        -c | --clear_out)   CLEAR_OUT="true";;
        -b | --build_img)   BUILD_IMG="true";;
        -s | --skip)        SKIP_KERNEL_BUILD="true";;
        -j | --jobs)        JOBS_NUMBER="$2";;
        -q | --quiet)       QUIET="true";;
        -l | --log)         LOG="true";;
        *);;
    esac
    shift;
done

#----------------------------------------------------------------------
# Functions block
#----------------------------------------------------------------------
print() {
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    blue=$(tput setaf 4)
    normal=$(tput sgr0)

    printf "%s\n" "${blue}$1"

    tput init
}

stdout_mode() {
    [ $QUIET ]  && echo "1>/dev/null"
    [ $LOG ]    && echo ">${KERNEL_OUT}/build_log.log"
}

continue() {
    while true; do
        read -n1 -p "$(print "Do you want to continue? (Y/n): ")" choice
        print ""
        case "$choice" in
            n|N) exit;;
            #y|Y) break;;
            *) break;;
        esac
    done
}

#----------------------------------------------------------------------
# Variables block
#----------------------------------------------------------------------
ROOT=$(dirname $(realpath "$0"))
ANDROID_ROOT=$ROOT/../android-13
KERNEL_SRC=$ROOT/../kernel
KERNEL_OUT=$ROOT/../kernel_out
KERNEL_DEFCONFIG=aosp_${PLATFORM_NAME}_${DEVICE_NAME}_defconfig

MKBOOTIMG_PATH=$ANDROID_ROOT/system/tools/mkbootimg/mkbootimg.py
MKDTIMG_PATH=$ANDROID_ROOT/system/libufdt/utils/src/mkdtboimg.py
AVBTOOL_PATH=$ANDROID_ROOT/external/avb/avbtool.py
UFDT_APPLY_OVERLAY=$ANDROID_ROOT/prebuilts/misc/linux-x86/libufdt/ufdt_apply_overlay
CLANG_PATH=$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r450784d/bin
#ANDROID_ROOT_12=$ROOT/../android-12
#CLANG_PATH=$ANDROID_ROOT_12/prebuilts/clang/host/linux-x86/clang-r416183b1/bin
#GCC_PATH=$ANDROID_ROOT_12/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin

PATH=${PATH}:${CLANG_PATH}

[ ! $JOBS_NUMBER ] && JOBS_NUMBER=$(nproc)

KERNEL_MAKE_ARGS="O=$KERNEL_OUT ARCH=arm64 DTC_OVERLAY_TEST_EXT=${UFDT_APPLY_OVERLAY} LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux- -j${JOBS_NUMBER} $(stdout_mode)"

[ $CLEAR_OUT ] && print "Clearing the kernel out folder..." && rm -fr $KERNEL_OUT

[ ! $PLATFORM_NAME ] && print "Platform name is empty abort..." && exit
[ ! $DEVICE_NAME ] && print "Device name is empty abort..." && exit

print "#----------------------------------------------------------------------"
print "#"
print "# Build system configuration:"
print "#    Script root:    ${ROOT}"
print "#    Android root:   ${ANDROID_ROOT}"
print "#    Kernel source:  ${KERNEL_SRC}"
print "#    Kernel out:     ${KERNEL_OUT}"
print "#    Platform name:  ${PLATFORM_NAME}"
print "#    Device name:    ${DEVICE_NAME}"
print "#"
print "#    Clear output folder:            $([ ! -z "$CLEAR_OUT" ]         && echo "$CLEAR_OUT"                    || echo "false")"
print "#    Skip kernel build:              $([ ! -z "$SKIP_KERNEL_BUILD" ] && echo "$SKIP_KERNEL_BUILD"            || echo "false")"
print "#    Build boot/dtbo images:         $([ ! -z "$BUILD_IMG" ]         && echo "$BUILD_IMG"                    || echo "false")"
print "#    Launch menuconfig before build: $([ ! -z "$MENUCONFIG" ]        && echo "$MENUCONFIG"                   || echo "false")"
print "#    Build quiet:                    $([ ! -z "$QUIET" ]             && echo "$QUIET"                        || echo "false")"
print "#    Save buildlog to the file:      $([ ! -z "$LOG" ]               && echo "${KERNEL_OUT}/build_log.log"   || echo "false")"
print "#    Threads:                        ${JOBS_NUMBER}"
print "#"
print "#    Clang version:                  $(${CLANG_PATH}/clang --version | head -n 1)"
print ""

#----------------------------------------------------------------------
# Build kernel block
#----------------------------------------------------------------------
if [ ! $SKIP_KERNEL_BUILD ]; then
    #[ $(pwd) != $KERNEL_SRC ] &&
    print "Entering kernel source directory: $KERNEL_SRC"
    cd $KERNEL_SRC

    [ ! -f $KERNEL_OUT/.config ] && ( ! make $KERNEL_MAKE_ARGS $KERNEL_DEFCONFIG ) && exit

    [ $MENUCONFIG ] && make $KERNEL_MAKE_ARGS menuconfig && continue

    find $KERNEL_OUT/arch/arm64/boot/dts/{qcom,somc}/ \( -name *.dtb -o -name *.dtbo \) -delete -printf "$(print "Remove old DTB: %p")" 2>/dev/null

    ( ! make $KERNEL_MAKE_ARGS ) && exit
fi

#----------------------------------------------------------------------
# Build images block
#----------------------------------------------------------------------
if [ $BUILD_IMG ] && [ -f "${ROOT}/${PLATFORM_NAME}_${DEVICE_NAME}.config" ]; then
    source ${ROOT}/${PLATFORM_NAME}_${DEVICE_NAME}.config
    print "#----------------------------------------------------------------------"
    print "#"
    print "# Image configuration:"
    print "#    KERNEL_BASE=${KERNEL_BASE}"
    print "#    KERNEL_PAGESIZE=${KERNEL_PAGESIZE}"
    print "#    KERNEL_TAGS_OFFSET=${KERNEL_TAGS_OFFSET}"
    print "#    RAMDISK_OFFSET=${RAMDISK_OFFSET}"
    print "#"
    print "#    BOOTIMAGE_PARTITION_SIZE=${BOOTIMAGE_PARTITION_SIZE}"
    print "#    DTBOIMAGE_PARTITION_SIZE=${DTBOIMAGE_PARTITION_SIZE}"
    print "#"
    print "#    KERNEL_CMDLINE=${KERNEL_CMDLINE}"
    print "#"
    print ""

    print "Creating boot.img..."
    python $MKBOOTIMG_PATH \
        --kernel $KERNEL_OUT/arch/arm64/boot/Image.gz-dtb \
        --ramdisk $ANDROID_ROOT/out/target/product/$DEVICE_NAME/ramdisk-recovery.img \
        --cmdline "${KERNEL_CMDLINE}" \
        --base ${KERNEL_BASE} \
        --pagesize ${KERNEL_PAGESIZE} \
        --os_version 13 \
        --os_patch_level 2023-05-05 \
        --ramdisk_offset ${RAMDISK_OFFSET} \
        --tags_offset ${KERNEL_TAGS_OFFSET} \
        --output $ANDROID_ROOT/out/target/product/$DEVICE_NAME/boot.img

    python $AVBTOOL_PATH add_hash_footer \
        --image $ANDROID_ROOT/out/target/product/$DEVICE_NAME/boot.img \
        --partition_size ${BOOTIMAGE_PARTITION_SIZE} \
        --partition_name boot \
        --prop com.android.build.boot.os_version:13 \
        --prop com.android.build.boot.fingerprint:$(cat $ANDROID_ROOT/out/target/product/$DEVICE_NAME/build_fingerprint.txt)

    if grep -w 'CONFIG_BUILD_ARM64_DT_OVERLAY=y' $KERNEL_OUT/.config > /dev/null; then
        #print "CONFIG_BUILD_ARM64_DT_OVERLAY found. Creating dtbo.img..."
        print "Creating dtbo.img..."
        python $MKDTIMG_PATH create $ANDROID_ROOT/out/target/product/$DEVICE_NAME/dtbo.img $KERNEL_OUT/arch/arm64/boot/dts/somc/*.dtbo

        python $AVBTOOL_PATH add_hash_footer \
            --image $ANDROID_ROOT/out/target/product/$DEVICE_NAME/dtbo.img \
            --partition_size ${DTBOIMAGE_PARTITION_SIZE} \
            --partition_name dtbo \
            --prop com.android.build.dtbo.fingerprint:$(cat $ANDROID_ROOT/out/target/product/$DEVICE_NAME/build_fingerprint.txt)
    fi
fi

print ""
print "# All job done! Time elapsed: $(date -ud "0 $(date +%s) seconds - $start_time seconds" +"%H hr %M min %S sec")"
print ""
