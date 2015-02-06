{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "openbsm-1.1p2";

  src = fetchurl {
    url    = "http://www.trustedbsd.org/downloads/openbsm-1.1-p2.tgz";
    sha256 = "1cwyxvl9mpssnfkq6cjblc2ssa91s2ar5zz9g1n6mfvfs0kmlf7k";
  };
}
