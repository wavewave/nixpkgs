{ stdenv, fetchurl, ghc, perl, gmp, ncurses, libiconv, fetchgit }:

let

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses}/lib"
    DYNAMIC_BY_DEFAULT = NO
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '';

  # We've gotta patch up cabal to fix https://github.com/haskell/cabal/issues/2320, but the fix is wrong for ghcjs (it compares against version 7.9, whereas ghcjs is always 0.1.0), so we have to use sed to patch in a False (below)
  CabalSrc = fetchgit {
    url = git://github.com/haskell/cabal.git;
    rev = "3c0e6480d5057dd616457a0ac0458e60946c9849";
    sha256 = "29c3014f8401cfa350b9688a9cc9847b73a520ab8f8a70e10d1cbe19c9282f61";
  };

in

stdenv.mkDerivation rec {
  version = "7.10.0.20150123";
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/7.10.1-rc2/${name}-src.tar.xz";
    sha256 = "0in5zsr2z545yln55c7mwi07x3za0874yxbpsj5xsb4vn3wrcrbn";
  };

  buildInputs = [ ghc perl libiconv ];

  preConfigure = ''
    cp -r ${CabalSrc}/* libraries/Cabal
    sed -i 's/HcPkg.useSingleFileDb = .*/HcPkg.useSingleFileDb = False/' libraries/Cabal/Cabal/Distribution/Simple/GHCJS.hs
    echo >mk/build.mk "${buildMK}"
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '';

  configureFlags = [
    "--with-gcc=${stdenv.cc}/bin/cc"
    "--with-gmp-includes=${gmp}/include" "--with-gmp-libraries=${gmp}/lib"
  ];

  enableParallelBuilding = true;

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" "--keep-file-symbols" ];

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres simons ];
    inherit (ghc.meta) license platforms;
  };

}
