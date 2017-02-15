%packages --excludedocs
alsa-lib
alsa-plugins-pulseaudio
gtk2
libxkbfile
pcsc-lite-libs
xterm
%end

%post --nochroot --log=/tmp/ks-vworkspace.log --erroronfail
mkdir -p /mnt/sysimage/tmp/vworkspace/
cp $BASE_DIRECTORY/vworkspace.bin /mnt/sysimage/tmp/vworkspace/vworkspace.bin
%end

%post --log=/mnt/sysimage/tmp/ks-vworkspace.log --erroronfail
chmod +x /tmp/vworkspace/vworkspace.bin
/tmp/vworkspace/vworkspace.bin --noexec --target /tmp/vworkspace/extracted/
dnf install --assumeyes -C --disablerepo fedora --disablerepo updates /tmp/vworkspace/extracted/*X64.rpm
rm -rf /tmp/vworkspace
%end
