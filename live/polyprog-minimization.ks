%packages
# These groups are added by the base fedora live system. We don't want them
-@anaconda-tools
-@dial-up
-@fonts
-@guest-desktop-agents
-@input-methods
-@multimedia
-@printing
-@standard

# installed manually but not wanted
-anaconda
-glibc-all-langpacks
-memtest86+

# wanted by core and base but not needed
-e2fsprogs
-openssh-server
-curl
-plymouth
-dnf-yum
-setup
-man-db
-grubby
-procps-ng
-sudo
-cronie
-openssh-clients
-audit
-parted
-vim-minimal
-plymouth-system-theme

-firewalld
-glx-utils
-grub2-efi
-usb_modeswitch
%end


# We remove last non-necessary stuff manually
%post --nochroot --erroronfail --log=/tmp/ks-manual-removal.log
set -eux

dnf --installroot /mnt/sysimage/ --assumeyes remove make systemd-bootchart pinentry GeoIP grubby kpartx trousers

rm -rf /mnt/sysimage/usr/share/locale
rm -rf /mnt/sysimage/usr/share/doc
%end


%post --nochroot --log=/tmp/ks-installed-package.log --erroronfail
dnf  --installroot /mnt/sysimage/ list installed | cut -d " " -f 1 | cut -d "." -f 1 | tail -n +3 | sort
dnf --installroot /mnt/sysimage/ clean all
%end
