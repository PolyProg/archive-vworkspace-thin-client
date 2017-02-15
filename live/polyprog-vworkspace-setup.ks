#######################################
## VWorkspace installation and setup ##
#######################################

# Package required for VWorkspace
%packages --excludedocs
alsa-lib
alsa-plugins-pulseaudio
gtk2
libxkbfile
pcsc-lite-libs
xterm
%end

# Copy necessary files to the live system
%post --nochroot --log=/tmp/ks-vworkspace.log --erroronfail
set -eux
mkdir -p /mnt/sysimage/tmp/vworkspace/
cp $BASE_DIRECTORY/vworkspace.bin /mnt/sysimage/tmp/vworkspace/vworkspace.bin
%end

# Install vworkspace
%post --erroronfail
set -eux
chmod +x /tmp/vworkspace/vworkspace.bin
/tmp/vworkspace/vworkspace.bin --noexec --target /tmp/vworkspace/extracted/
dnf install --assumeyes -C --disablerepo fedora --disablerepo updates /tmp/vworkspace/extracted/*X64.rpm
rm -rf /tmp/vworkspace
%end
