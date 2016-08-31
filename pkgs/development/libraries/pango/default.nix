{ stdenv, fetchurl, pkgconfig, libXft, cairo, harfbuzz
, libintlOrEmpty, gobjectIntrospection, glib
, darwin, libtool
}:

with stdenv.lib;

let
  ver_maj = "1.40";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "pango-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${ver_maj}/${name}.tar.xz";
    sha256 = "e27af54172c72b3ac6be53c9a4c67053e16c905e02addcf3a603ceb2005c1a40";
  };

  outputs = [ "dev" "out" "bin" "docdev" ];

  buildInputs = [ gobjectIntrospection glib libtool ];
  nativeBuildInputs = [ pkgconfig ]
  #++
  #(optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
   # CoreGraphics
   #CoreText
   # ApplicationServices
    #Carbon
    #darwin.cf-private
  #]))

  ;
  propagatedBuildInputs = [ cairo harfbuzz ] ++ libintlOrEmpty

  # libXft ] ++ libintlOrEmpty
  # ++ (optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
   # CoreGraphics
   # CoreText
   # ApplicationServices
   # Carbon
   # darwin.cf-private
  #]))
;
  enableParallelBuilding = true;

  doCheck = false; # test-layout fails on 1.38.0
  # jww (2014-05-05): The tests currently fail on Darwin:
  #
  # ERROR:testiter.c:139:iter_char_test: assertion failed: (extents.width == x1 - x0)
  # .../bin/sh: line 5: 14823 Abort trap: 6 srcdir=. PANGO_RC_FILE=./pangorc ${dir}$tst
  # FAIL: testiter

  configureFlags = optional stdenv.isDarwin [
    "--without-xft"
    "--disable-dependency-tracking"
    "--disable-silent-rules"
    "--enable-introspection=yes"
    "--enable-static"
  ] ;

  meta = with stdenv.lib; {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = http://www.pango.org/;
    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin urkud ];
    platforms = with platforms; linux ++ darwin;
  };
}
