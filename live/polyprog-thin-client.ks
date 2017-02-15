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
services --enabled=NetworkManager --disabled=network,sshd
timezone Europe/Zurich

# Package fetching configuration
url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch


bootloader --append="rd.live.ram=1"


%post --nochroot --erroronfail
rsync -raAHx $BASE_DIRECTORY/skel/* /mnt/sysimage/

#cp $BASE_DIRECTORY/packages/* /mnt/sysimage/tmp/

# enable timesyncd

# set hostname

#chown root:root /etc/NetworkManager/dispatcher.d/90-sethostname
#chmod 755 /etc/NetworkManager/dispatcher.d/90-sethostname

#chown root:root /etc/polkit-1/rules.d/00-restrict.rules
#chown root:root /etc/salt/minion

#chown root:root -R /usr/local/sbin

%end
