{ cabal, blazeBuilder, doubleConversion, hoodleTypes, lens, strict
, text
}:

cabal.mkDerivation (self: {
  pname = "hoodle-builder";
  version = "0.3";
  sha256 = "0mj58g7kfr5hpqv6idjb24d3gdh25z5x2ym62c6ckm5g3f4x3jm9";
  buildDepends = [
    blazeBuilder doubleConversion hoodleTypes lens strict text
  ];
  meta = {
    description = "text builder for hoodle file format";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
