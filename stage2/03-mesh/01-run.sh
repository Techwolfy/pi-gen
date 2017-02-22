#!/bin/bash -e

#Startup script
install -v -d											${ROOTFS_DIR}/etc/mesh
install -v -m 755 files/up.sh							${ROOTFS_DIR}/etc/mesh/
install -v -m 644 files/mesh							${ROOTFS_DIR}/etc/cron.d/

#Web server config
install -v -m 644 files/nginx.conf						${ROOTFS_DIR}/etc/nginx/nginx.conf
install -v -m 644 files/mesh.local						${ROOTFS_DIR}/etc/nginx/sites-available/

#Website files
install -v -d											${ROOTFS_DIR}/var/www/mesh
