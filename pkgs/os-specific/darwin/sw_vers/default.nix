{ stdenv, binutils_raw }:

stdenv.mkDerivation {
  name = "sw_vers";
  buildCommand = ''
    mkdir -p $out/bin
    cat >$out/bin/sw_vers <<EOF
      echo "10.9.4"
    EOF
    chmod a+x $out/bin/sw_vers
  '';
}