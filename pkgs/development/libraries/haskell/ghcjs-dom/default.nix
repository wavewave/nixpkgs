{ cabal, fetchgit, ghc, mtl
, buildType ? if ghc.ghc.pname or null == "ghcjs" then "jsffi" else "webkit"
, ghcjsBase ? null # jsffi dependencies
, glib ? null, transformers ? null, gtk ? null, webkit ? null # webkit dependencies
}:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.1.1.3";
  src = fetchgit {
    url = git://github.com/ryantrinkle/ghcjs-dom.git;
    rev = "90b52182ab3d2ca5cbed7b2fbb33fa06f280771e";
    sha256 = "949a661516206252b36dc817c07ababb7f50a389661d838f0fee0be15085aff9";
  };
  buildDepends = [ mtl ] ++ (if buildType == "jsffi" then [ ghcjsBase ] else if buildType == "webkit" then [ glib transformers gtk webkit ] else throw "unrecognized buildType");
  configureFlags = if buildType == "jsffi" then [ ] else if buildType == "webkit" then [ "-f-ghcjs" "-fwebkit" "-f-gtk3" ] else throw "unrecognized buildType";
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
