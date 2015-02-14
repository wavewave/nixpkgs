{ stdenv, binutils_raw }:

stdenv.mkDerivation {
  name = "sw_vers";
  buildCommand = ''
    mkdir -p $out/bin
    cat >$out/bin/sw_vers <<EOF
    #!${stdenv.shell}
    if test "\$#" -eq 0 ;
      then 
        echo "ProductName:    Mac OS X"
        echo "ProductVersion: 10.9.4"
        echo "BuildVersion:   13E28"
      else
        echo "10.9.4"
    fi
    EOF
    chmod a+x $out/bin/sw_vers
  '';
}