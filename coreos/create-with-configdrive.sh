#!/usr/bin/env bash

DOMAIN='coreos1'

# FIXME! 
# place coreos_production_qemu_image.img in /var/lib/uvtool/libvirt/images/
# download from http://storage.core-os.net/coreos/amd64-usr/alpha/coreos_production_qemu_image.img.bz2 if missing.
#   unzip/convert to destination while streaming possible?

uvt-kvm create \
  --backing-image-file coreos_production_qemu_image.img \
  $DOMAIN

virsh destroy $DOMAIN

mkdir -p /tmp/new-drive/openstack/latest
cp user_data /tmp/new-drive/openstack/latest/user_data
mkisofs -R -V config-2 -o /tmp/new-drive/configdrive.iso /tmp/new-drive
sudo cp /tmp/new-drive/configdrive.iso /var/lib/uvtool/libvirt/images/coreos1-ds.qcow
#^FIXME! convert to qcow?
rm -r /tmp/new-drive

virsh start $DOMAIN

uvt-kvm wait $DOMAIN --remote-wait-user core --insecure