{ mkDerivation # cabal.mkDerivation
, test-framework # testFramework
, test-framework-hunit # testFrameworkHunit
, test-framework-quickcheck2 # testFrameworkQuickcheck2
, data-default # dataDefault
, ghc-paths # ghcPaths
, haskell-src-exts # haskellSrcExts
, haskell-src-meta # haskellSrcMeta
, optparse-applicative # optparseApplicative
, system-fileio # systemFileio
, system-filepath # systemFilepath
, text-binary # textBinary
, unordered-containers # unorderedContainers
, cabal-install # cabalInstall
, wl-pprint-text # wlPprintText
, base16-bytestring # base16Bytestring
, executable-path # executablePath
, transformers-compat # transformersCompat
, haddock-api # haddockApi
, ghcjs-prim # ghcjsPrim
, regex-posix # regexPosix

, ghc, gmp
, jailbreak-cabal

, nodejs, stdenv, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, time
, zlib, aeson, attoparsec, bzlib, hashable
, lens
, parallel, safe, shelly, split, stringsearch, syb
, tar, terminfo
, vector, yaml, fetchgit, Cabal
, alex, happy, git, gnumake, autoconf, patch
, automake, libtool
, cryptohash
, haddock, hspec, xhtml, primitive, cacert, pkgs
, coreutils
, cc, libiconv
}:
let
  version = "0.1.0";
  libDir = "share/ghcjs/${pkgs.stdenv.system}-${version}-${ghc.version}/ghcjs";
  ghcjsBoot = fetchgit {
    url = git://github.com/ryantrinkle/ghcjs-boot.git;
    rev = "7e9c4df151619b96d97523b75072dd4d0af4115c";
    sha256 = "5a96be9cf0444dc69118544657f4551044b6f7ec864bb939e5ec223e25d2848e";
    fetchSubmodules = true;
  };
  shims = fetchgit {
    url = git://github.com/ghcjs/shims.git;
    rev = "6ada4bf1a084d1b80b993303d35ed863d219b031";
    sha256 = "6c93ebd4c4178257db93d4469d9bd38f7572bd60d2ae1baa58abf53ca4b40e36";
  };
in mkDerivation (rec {
  pname = "ghcjs";
  inherit version;
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs.git;
    rev = "44df08ad870a13f89c89f688ba2718347b63374c";
    sha256 = "bce80501a295de840c90b43eb5b2157ebfabd1276721053dc526521fc60cb6f3";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  doHaddock = false;
  doCheck = false;
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib data-default ghc-paths hashable haskell-src-exts haskell-src-meta
    lens optparse-applicative parallel safe shelly split
    stringsearch syb system-fileio system-filepath tar terminfo text-binary
    unordered-containers vector wl-pprint-text yaml
    alex happy git gnumake autoconf automake libtool patch gmp
    base16-bytestring cryptohash executable-path haddock-api
    transformers-compat QuickCheck haddock hspec xhtml
    ghcjs-prim regex-posix libiconv
  ];
  buildTools = [ nodejs git ];
  testDepends = [
    HUnit test-framework test-framework-hunit
  ];
  patches = [ ./ghcjs.patch ];
  postPatch = ''
    substituteInPlace Setup.hs --replace "/usr/bin/env" "${coreutils}/bin/env"
    substituteInPlace src/Compiler/Info.hs --replace "@PREFIX@" "$out"
    substituteInPlace src-bin/Boot.hs --replace "@PREFIX@" "$out"
    for f in ghcjs.cabal utils/patch/ghcjs-patch.cabal test/ghcjs-testsuite.cabal ; do
      sed -i "s/\bshelly.*,/shelly -any,/g" "$f"
    done
    sed -i 's|\("--with-compiler", ghcjs \^\. pgmLocText\)|\1, "--with-gcc", "${cc}/bin/cc"|' src-bin/Boot.hs
  '';
  preBuild = ''
    local topDir=$out/${libDir}
    mkdir -p $topDir

    cp -r ${ghcjsBoot} $topDir/ghcjs-boot
    chmod -R u+w $topDir/ghcjs-boot

    cp -r ${shims} $topDir/shims
    chmod -R u+w $topDir/shims
  '';
  postInstall = ''
    PATH=$out/bin:$PATH LD_LIBRARY_PATH=${gmp}/lib:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot \
        --dev \
        --with-cabal ${cabal-install}/bin/cabal \
        --with-gmp-includes ${gmp}/include \
        --with-gmp-libraries ${gmp}/lib
  '';
  passthru = {
    inherit libDir;
    setupBuilder = "${ghc}/bin/ghc";
    ghcCommand = "ghcjs";
    runCommand = x: "${nodejs}/bin/node ${x}.jsexe/all.js";
    pkgCommand = "ghcjs-pkg";
    extraConfigureFlags = [ "--ghcjs" ];
  };
  license = stdenv.lib.licenses.bsd3;
/*
  meta = {
    homepage = "https://github.com/ghcjs/ghcjs";
    description = "GHCJS is a Haskell to JavaScript compiler that uses the GHC API";
    license = stdenv.lib.licenses.bsd3;
    platforms = ghc.meta.platforms;
    maintainers = [ stdenv.lib.maintainers.jwiegley ];
  };
*/
})
