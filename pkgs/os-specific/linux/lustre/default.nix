{ stdenv, fetchurl, rpmextract
, autoconf, automake
, kernel, libyaml, zlib
}:

let

  kernelModDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}";
  kernelSourceDir = "${kernelModDir}/source";
  kernelBuildDir = "${kernelModDir}/build";

in

stdenv.mkDerivation rec {
  pname = "lustre";
  version = "2.13.0";

  src = fetchurl {
    url = "https://downloads.whamcloud.com/public/lustre/lustre-${version}/el8/client/RPMS/x86_64/lustre-client-dkms-${version}-1.el8.noarch.rpm";
    sha256 = "0f8scc05086kik97may2l3wvlwj9s89qiffxl7cdsrxgvsac5zg5";
  };
  sourceRoot = "${pname}/usr/src/lustre-client-${version}";

  outputs = [ "out" "kmod" ];

  nativeBuildInputs = [
                        rpmextract
                        autoconf
                        automake
                      ];
  buildInputs = [ kernel.dev libyaml zlib ];

  unpackCmd = ''
    mkdir ${pname} && pushd ${pname}
    rpmextract $curSrc
    popd
  '';

  configureFlags = [
    "--enable-modules"
    "--disable-iokit"
    "--disable-snmp"
    "--disable-doc"
    "--enable-utils"
    "--disable-tests"
    "--disable-maintainer-mode"
    "--disable-manpages"
    "--disable-mpitests"
    "--disable-server"
    "--with-linux=${kernelSourceDir}"
    "--with-linux-obj=${kernelBuildDir}"
    "--with-linux-config=${kernelBuildDir}/.config"
  ];

  kmodOut = "$kmod/lib/modules/${kernel.modDirVersion}";

  postInstall = ''
    mkdir -p ${kmodOut}

    cp ./lnet/klnds/o2iblnd/ko2iblnd.ko ${kmodOut}
    cp ./lnet/klnds/socklnd/ksocklnd.ko ${kmodOut}
    cp ./lnet/lnet/lnet.ko ${kmodOut}
    cp ./lnet/selftest/lnet_selftest.ko ${kmodOut}
    cp ./lustre/llite/lustre.ko ${kmodOut}
    cp ./lustre/lmv/lmv.ko ${kmodOut}
    cp ./lustre/tests/kernel/kinode.ko ${kmodOut}
    cp ./lustre/obdecho/obdecho.ko ${kmodOut}
    cp ./lustre/obdclass/obdclass.ko ${kmodOut}
    cp ./lustre/obdclass/llog_test.ko ${kmodOut}
    cp ./lustre/lov/lov.ko ${kmodOut}
    cp ./lustre/osc/osc.ko ${kmodOut}
    cp ./lustre/fid/fid.ko ${kmodOut}
    cp ./lustre/ptlrpc/ptlrpc.ko ${kmodOut}
    cp ./lustre/mdc/mdc.ko ${kmodOut}
    cp ./lustre/fld/fld.ko ${kmodOut}
    cp ./lustre/mgc/mgc.ko ${kmodOut}
    cp ./libcfs/libcfs/libcfs.ko ${kmodOut}

    cp ./lustre/utils/mount.lustre $out/bin
    cp ./lustre/utils/mount.lustre_tgt $out/bin
  '';

  meta = with stdenv.lib; {
    description = "lustre";
    homepage    = https://lustre.org;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ ianwookim ];
    platforms   = platforms.linux;
  };
}
