# Upstream configuration
%include ../upstream-live/fedora-live-base.ks
%include ../upstream-live/fedora-live-minimization.ks

# Custom configuration
# Beware that order matters and the minimization should be last in the list
%include polyprog-packages.ks
%include polyprog-vworkspace-setup.ks
%include polyprog-minimization.ks


# Override local values
lang en_GB.UTF-8
keyboard --vckeymap ch-fr --xlayouts='ch (fr)' ch
firewall --disabled
services --enabled=NetworkManager --disabled=network,sshd
timezone Europe/Zurich

# Package fetching configuration
url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch


%post --nochroot --erroronfail
rsync -raAHx $BASE_DIRECTORY/skel/* /mnt/sysimage/

chown root:root /mnt/sysimage/usr/local/bin/run.py
chown root:root /mnt/sysimage/etc/sysconfig/network-scripts/*

# enable timesyncd


#chown root:root /etc/polkit-1/rules.d/00-restrict.rules
#chown root:root -R /usr/local/sbin

%end


%post
systemctl daemon-reload
%end