{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Disable GHC 7.10.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # We have Cabal 1.22.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = null; };

  # GHC 7.10.x's Haddock binary cannot generate hoogle files.
  # https://ghc.haskell.org/trac/ghc/ticket/9921
  mkDerivation = drv: super.mkDerivation (drv // { doHoogle = false; });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;

  # These used to be core packages in GHC 7.8.x.
  old-locale = self.old-locale_1_0_0_7;
  old-time = self.old-time_1_1_0_3;

  # We have transformers 4.x
  mtl = self.mtl_2_2_1;
  transformers-compat = disableCabalFlag super.transformers-compat "three";

  # We have time 1.5
  aeson = disableCabalFlag super.aeson "old-locale";

  # Setup: At least the following dependencies are missing: base <4.8
  hspec-expectations = overrideCabal super.hspec-expectations (drv: {
    patchPhase = "sed -i -e 's|base < 4.8|base|' hspec-expectations.cabal";
  });
  utf8-string = overrideCabal super.utf8-string (drv: {
    patchPhase = "sed -i -e 's|base >= 3 && < 4.8|base|' utf8-string.cabal";
  });

  # bos/attoparsec#92
  attoparsec = dontCheck super.attoparsec;

  # test suite hangs silently for at least 10 minutes
  split = dontCheck super.split;

  # Test suite fails with some (seemingly harmless) error.
  # https://code.google.com/p/scrapyourboilerplate/issues/detail?id=24
  syb = dontCheck super.syb;

  # Test suite has stricter version bounds
  retry = dontCheck super.retry;

  # Test suite fails with time >= 1.5
  http-date = dontCheck super.http-date;

  # Version 1.19.5 fails its test suite.
  happy = dontCheck super.happy;

  # Test suite hangs silently without consuming any CPU.
  # https://github.com/ndmitchell/extra/issues/4
  extra = dontCheck super.extra;

  # encoding fails to build on GHC 7.10 because of the Applicative-Monad Proposal
  encoding = overrideCabal super.encoding (drv: {
    sha256 = null;
    src = pkgs.fetchdarcs {
      url = http://static.ryantrinkle.com/encoding;
      rev = "0.7.0.3";
      sha256 = "1ssg9galkpbig05q5vqhqzljk29dg9z9hs02aqjs2ljqqxx1xnjf";
    };
    version = "0.7.0.3";
  });

  # intervals fails to build on GHC 7.10 due to 'null' being added to Foldable
  intervals = overrideCabal super.intervals (drv: {
    sha256 = null;
    src = pkgs.fetchgit {
      url = git://github.com/pacak/intervals;
      rev = "9f0eb8d0278745e0a46580d379dab57de8c9d7a0";
      sha256 = "3da3c33ef57afc488f03c8b8a52925c8c6bf4cf8aac854da48dd565c7b61384d";
    };
    version = "0.7.0.2";
  });
}
