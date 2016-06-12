{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, utilmacros, python
, mesa, libX11
}:

stdenv.mkDerivation rec {
  name = "epoxy-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    #owner = "anholt";
    owner = "yaronct";
    repo = "libepoxy";
    #rev = "v${version}";
    rev = "c342cba2a1b882f30b1864b5819bdb8986f5ee9c";
    sha256 = "b668d2120e33594d79280caf782251cd5f89a47e1b6c0c6ed60486abe90cf8b8";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig utilmacros python ];
  buildInputs = [ mesa libX11 ];

  preConfigure = stdenv.lib.optional stdenv.isDarwin ''
    substituteInPlace configure --replace build_glx=no build_glx=yes
    substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  '';

  meta = with stdenv.lib; {
    description = "A library for handling OpenGL function pointer management";
    homepage = https://github.com/anholt/libepoxy;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
