{ stdenv, binutils_raw }:

stdenv.mkDerivation {
  name = "sw_vers";
  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${binutils_raw}/bin/sw_vers $out/bin/sw_vers
  '';
}