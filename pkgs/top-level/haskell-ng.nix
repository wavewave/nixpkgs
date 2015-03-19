{ pkgs, callPackage, stdenv }:

rec {

  lib = import ../development/haskell-modules/lib.nix { inherit pkgs; };

  compiler = {

    ghc6102Binary = callPackage ../development/compilers/ghc/6.10.2-binary.nix ({ gmp = pkgs.gmp4; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc704Binary = callPackage ../development/compilers/ghc/7.0.4-binary.nix ({ gmp = pkgs.gmp4; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc742Binary = callPackage ../development/compilers/ghc/7.4.2-binary.nix ({ gmp = pkgs.gmp4; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });

    ghc6104 = callPackage ../development/compilers/ghc/6.10.4.nix ({ ghc = compiler.ghc6102Binary; gmp = pkgs.gmp.override { withStatic = true; }; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc6123 = callPackage ../development/compilers/ghc/6.12.3.nix ({ ghc =
    compiler.ghc6102Binary; gmp = pkgs.gmp.override { withStatic = true; }; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc704 = callPackage ../development/compilers/ghc/7.0.4.nix ({ ghc = compiler.ghc704Binary; gmp = pkgs.gmp.override { withStatic = true; }; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc722 = callPackage ../development/compilers/ghc/7.2.2.nix ({ ghc = compiler.ghc704Binary; gmp = pkgs.gmp.override { withStatic = true; }; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc742 = callPackage ../development/compilers/ghc/7.4.2.nix ({ ghc = compiler.ghc704Binary; gmp = pkgs.gmp.override { withStatic = true; }; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc763 = callPackage ../development/compilers/ghc/7.6.3.nix ({ ghc = compiler.ghc704Binary; gmp = pkgs.gmp.override { withStatic = true; }; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc784 = callPackage ../development/compilers/ghc/7.8.4.nix ({ ghc = compiler.ghc742Binary; gmp = pkgs.gmp.override { withStatic = true; }; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc7101 = callPackage ../development/compilers/ghc/7.10.1.nix ({ ghc = compiler.ghc784; gmp = pkgs.gmp.override { withStatic = true; }; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix ({ ghc = packages.ghc784.ghc; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc = compiler.ghc784;

    ghcjs = (packages.ghc7101.override {
      overrides = self: super: {
#        mkDerivation = drv: super.mkDerivation (drv // { doHaddock = false; });
#        Cabal = self.Cabal_1_22_0_0;
#        haddock-api = super.haddock-api.override { Cabal = null; };
#        haddock = super.haddock.override { Cabal = null; };
      };
    }).callPackage ../development/compilers/ghcjs {
      ghc = compiler.ghc7101;
      gmp = "${pkgs.gmp.override { withStatic = true; }}";
    };

  };

  packages = {

    ghc6104 = callPackage ../development/haskell-modules { ghc = compiler.ghc6104; };
    ghc6123 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc6123;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-6.12.x.nix { };
    };
    ghc704 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc704;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.0.x.nix { };
    };
    ghc722 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc722;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.2.x.nix { };
    };
    ghc742 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc742;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.4.x.nix { };
    };
    ghc763 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc763;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.6.x.nix { };
    };
    ghc784 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc784;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.8.x.nix { };
    };
    ghc7101 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7101;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcjs = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjs;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix {
        parent = packages.ghc7101;
      };
      jailbreak-cabal = "${packages.ghc7101.jailbreak-cabal}";
      hsc2hs = "${compiler.ghc7101}/bin/hsc2hs";
    };

  };
}
