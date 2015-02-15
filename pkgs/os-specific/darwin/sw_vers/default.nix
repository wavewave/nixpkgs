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
    elif [ "\$1" = "-ProductName" ];
    then
        echo "Mac OS X"
    elif [ "\$1" = "-ProductVersion" ];
    then
        echo "10.9.4"
    elif [ "\$1" = "-BuildVersion" ];
    then
        echo "13E28"
    fi
    EOF
    chmod a+x $out/bin/sw_vers
  '';
}