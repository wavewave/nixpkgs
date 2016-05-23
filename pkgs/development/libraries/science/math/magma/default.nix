{ stdenv, fetchurl, cmake, gfortran, cudatoolkit, libpthreadstubs, liblapack }:

with stdenv.lib;

let version = "2.0.2";

in stdenv.mkDerivation {
  name = "magma-${version}";
  src = fetchurl {
    url = "http://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${version}.tar.gz";
    sha256 = "0w3z6k1npfh0d3r8kpw873f1m7lny29sz2bvvfxzk596d4h083lk";
    name = "magma-${version}.tar.gz";
  };

  buildInputs = [ gfortran cudatoolkit libpthreadstubs liblapack cmake ];

  doCheck = false;
  #checkTarget = "tests";

  enableParallelBuilding=true;

  # MAGMA's default CMake setup does not care about installation. So we copy files directly.
  installPhase = ''
    mkdir $out
    echo $PWD
    cp -a lib $out
    cp -a ../include $out
    cp -a sparse-iter $out    
  '';

  meta = with stdenv.lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = "http://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ianwookim ];
  };
}
