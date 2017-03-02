#!/bin/bash -e

#Install custom RTL8192CU drivers
RTLWIFI_DIR=lib/modules/4.4.48+/kernel/drivers/net/wireless/realtek/rtlwifi
install -v -d											${ROOTFS_DIR}/${RTLWIFI_DIR}
install -v -m 644 files/rtlwifi/rtlwifi.ko				${ROOTFS_DIR}/${RTLWIFI_DIR}/rtlwifi.ko
install -v -m 644 files/rtlwifi/rtl_usb.ko				${ROOTFS_DIR}/${RTLWIFI_DIR}/rtl_usb.ko
install -v -m 644 files/rtlwifi/rtl8192c-common.ko		${ROOTFS_DIR}/${RTLWIFI_DIR}/rtl8192c-common.ko
install -v -m 644 files/rtlwifi/rtl8192cu.ko			${ROOTFS_DIR}/${RTLWIFI_DIR}/rtl8192cu.ko
install -v -m 644 files/blacklist-rtl8192cu.conf		${ROOTFS_DIR}/etc/modprobe.d/blacklist-rtl8192cu.conf

#Update module dependencies
on_chroot << 'EOF'
depmod -a $(ls -1 /lib/modules | head -n 1)
EOF

#Install startup script
install -v -d											${ROOTFS_DIR}/etc/mesh
install -v -m 755 files/up.sh							${ROOTFS_DIR}/etc/mesh/
install -v -m 644 files/mesh							${ROOTFS_DIR}/etc/cron.d/

#Install web server config
install -v -m 644 files/nginx.conf						${ROOTFS_DIR}/etc/nginx/nginx.conf

#Install website files
install -v -d											${ROOTFS_DIR}/var/www/mesh
install -v -m 644 files/index.php						${ROOTFS_DIR}/var/www/mesh/index.php

echo "Mesh config installed."
