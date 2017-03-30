# Upstream configuration
%include ../upstream-live/fedora-live-base.ks
%include ../upstream-live/fedora-live-minimization.ks

# Custom configuration
# Beware that order matters and the minimization should be last in the list
%include polyprog-packages.ks
%include polyprog-vworkspace-setup.ks
%include polyprog-minimization.ks


# Override local values and base setup
lang en_GB.UTF-8
keyboard --vckeymap ch-fr --xlayouts='ch (fr)' ch
firewall --disabled
services --enabled=NetworkManager --disabled=network,sshd
timezone Europe/Zurich

# Package fetching configuration
url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch


%post --nochroot --erroronfail --log /tmp/ks-copy-and-enable
set -eux
#let's copy files to the system
rsync -raAHx $BASE_DIRECTORY/skel/* /mnt/sysimage/
cp $BASE_DIRECTORY/skel/.setup.env /mnt/sysimage/

# let's change access rights correctly
chown -R root:root /mnt/sysimage/usr/local/bin/
chown -R root:root /mnt/sysimage/etc/systemd/system
chown root:root /mnt/sysimage/etc/polkit-1/rules.d/00-restrict.rules

chown root:root mnt/sysimage/.setup.env
chmod 400 /mnt/sysimage/.setup.env

mkdir -p /mnt/sysimage/etc/systemd/system/sysinit.targets.wants/
ln -sf /usr/lib/systemd/system/systemd-timesyncd.service /mnt/sysimage/etc/systemd/system/sysinit.targets.wants/systemd-timesyncd.service

%end


%post --erroronfail
set -eux
systemctl daemon-reload

%end