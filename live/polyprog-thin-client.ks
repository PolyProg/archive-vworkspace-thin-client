# Upstream configuration
%include ../upstream-live/fedora-live-base.ks
%include ../upstream-live/fedora-live-minimization.ks

# Custom configuration
%include polyprog-packages.ks
%include polyprog-minimization.ks
%include polyprog-vworkspace-setup.ks

# Override local values
lang en_GB.UTF-8
keyboard --vckeymap ch-fr --xlayouts='ch (fr)' ch
timezone Europe/Zurich

# Package fetching configuration
url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch

bootloader --append rd.live.ram=1


%post --nochroot --log=/mnt/sysimage/root/post-setup.log
rsync -raAHx $BASE_DIRECTORY/skel/* /mnt/sysimage/

#cp $BASE_DIRECTORY/packages/* /mnt/sysimage/tmp/

%end


%post

# enable timesyncd

# set hostname

#chown root:root /etc/NetworkManager/dispatcher.d/90-sethostname
#chmod 755 /etc/NetworkManager/dispatcher.d/90-sethostname

#chown root:root /etc/polkit-1/rules.d/00-restrict.rules
#chown root:root /etc/salt/minion

#chown root:root -R /usr/local/sbin

%end
