%packages
-@anaconda-tools
-anaconda
-abrt-cli

-@guest-desktop-agents
-@multimedia
-@printing
-@fonts

# documentation
-fedora-release-notes
-python-systemd-doc

# filesystems
-cryptsetup
-dosfstools
-ntfs-3g
-btrfs-progs
-e2fsprogs
-ntfsprogs
-smartmontools

# Networking
-@dial-up
-telnet
-traceroute

# security
-audit
-firewalld
-sudo

# locales and fonts
-ibus-libpinyin
%end

# Here we cleanup packages that could not be removed from the installation
%post --erroronfail
set -eux
dnf --assumeyes remove GeoIP cpp plymouth
dnf clean all
%end
