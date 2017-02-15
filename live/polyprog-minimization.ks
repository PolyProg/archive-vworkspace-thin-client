%packages
-@anaconda-tools
-anaconda

-@guest-desktop-agents
-@multimedia
-@printing

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
%end

# Here we cleanup packages that could not be removed from the installation
%post --erroronfail
set -eux
dnf --assumeyes remove GeoIP cpp plymouth libpinyin
dnf clean all
%end
