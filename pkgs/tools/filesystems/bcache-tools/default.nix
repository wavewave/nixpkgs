{ stdenv, fetchurl, pkgconfig, utillinux, kmod }:

stdenv.mkDerivation rec {
  name = "bcache-tools-${version}";
  version = "1.0.5";

  src = fetchurl {
    url = "https://github.com/g2p/bcache-tools/archive/v${version}.tar.gz";
    sha256 = "1abf86xcnj601lddig3kmn26jrf8q8xhcyszf5pxrcs5ym72jj8l";
  };

  buildInputs = [ pkgconfig utillinux ];

  # * Remove broken install rules (they ignore $PREFIX) for stuff we don't need
  #   anyway (it's distro specific stuff).
  # * Fixup absolute path to modprobe.
  prePatch = ''
    sed -e "/INSTALL.*initramfs\/hook/d" \
        -e "/INSTALL.*initcpio\/install/d" \
        -e "/INSTALL.*dracut\/module-setup.sh/d" \
        -i Makefile

    sed -e "s|/sbin/modprobe|${kmod}/sbin/modprobe|" -i bcache-register
  '';

  preBuild = ''
    export makeFlags="$makeFlags PREFIX=\"$out\" UDEVLIBDIR=\"$out/lib/udev/\"";
  '';

  preInstall = ''
    mkdir -p "$out/sbin" "$out/lib/udev/rules.d" "$out/share/man/man8"
  '';

  meta = with stdenv.lib; {
    description = "User-space tools required for bcache (Linux block layer cache)";
    longDescription = ''
      Bcache is a Linux kernel block layer cache. It allows one or more fast
      disk drives such as flash-based solid state drives (SSDs) to act as a
      cache for one or more slower hard disk drives.
      
      This package contains the required user-space tools.

      User documentation is in Documentation/bcache.txt in the Linux kernel
      tree.
    '';
    homepage = http://bcache.evilpiepirate.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
