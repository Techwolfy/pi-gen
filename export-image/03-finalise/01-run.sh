#!/bin/bash -e

IMG_FILE="${STAGE_WORK_DIR}/${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.img"

on_chroot << EOF
/etc/init.d/fake-hwclock stop
hardlink -t /usr/share/doc
EOF

if [ -d ${ROOTFS_DIR}/home/pi/.config ]; then
	chmod 700 ${ROOTFS_DIR}/home/pi/.config
fi

rm -f ${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache
rm -f ${ROOTFS_DIR}/usr/sbin/policy-rc.d
rm -f ${ROOTFS_DIR}/usr/bin/qemu-arm-static
if [ -e ${ROOTFS_DIR}/etc/ld.so.preload.disabled ]; then
        mv ${ROOTFS_DIR}/etc/ld.so.preload.disabled ${ROOTFS_DIR}/etc/ld.so.preload
fi

update_issue $(basename ${EXPORT_DIR})
install -m 644 ${ROOTFS_DIR}/etc/rpi-issue ${ROOTFS_DIR}/boot/issue.txt
install files/LICENSE.oracle ${ROOTFS_DIR}/boot/

ROOT_DEV=$(mount | grep "${ROOTFS_DIR} " | cut -f1 -d' ')

unmount ${ROOTFS_DIR}
zerofree -v ${ROOT_DEV}

unmount_image ${IMG_FILE}

mkdir -p ${DEPLOY_DIR}

rm -f ${DEPLOY_DIR}/image_${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.img

echo cp ${IMG_FILE} ${DEPLOY_DIR}/image_${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.img
pushd ${STAGE_WORK_DIR} > /dev/null
cp $(basename ${IMG_FILE}) ${DEPLOY_DIR}/${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.img
popd > /dev/null
