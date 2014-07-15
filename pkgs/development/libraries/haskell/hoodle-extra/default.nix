{ cabal, aeson, aesonPretty, attoparsec, base64Bytestring, binary
, cmdargs, conduit, either, filepath, hoodleParser, hoodleTypes
, httpConduit, lens, monadLoops, mtl, networkSimple, pureMD5
, resourcet, text, time, transformers, unorderedContainers
, xournalParser
}:

cabal.mkDerivation (self: {
  pname = "hoodle-extra";
  version = "0.1";
  sha256 = "1mqx4qia457n8v4pdyd8mc8h7ybzx5asxm2d4p9ws5g2q4ybmshy";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty attoparsec base64Bytestring binary cmdargs
    conduit either filepath hoodleParser hoodleTypes httpConduit lens
    monadLoops mtl networkSimple pureMD5 resourcet text time
    transformers unorderedContainers xournalParser
  ];
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "extra hoodle tools";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
