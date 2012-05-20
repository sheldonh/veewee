#!/bin/sh

date > /etc/vagrant_box_build_time

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)

yum -y install \
  dkms \
  gcc \
  make \
  ruby \
  ruby-devel \
  rubygems \

yum clean all

for cdrom in /dev/cdrom*; do
  mount ${cdrom} /mnt
  if [ -x /mnt/VBoxLinuxAdditions.run ]; then
    sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    restorecon -R /opt/VBoxGuestAdditions-${VBOX_VERSION}
    break
  else
    umount /mnt
  fi
done
[ -d /opt/VBoxGuestAdditions-${VBOX_VERSION} ] || exit 1

gem install chef puppet --no-rdoc --no-ri

exit

# EOF
