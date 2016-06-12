{ stdenv, fetchFromGitHub # , autoreconfHook
, pkgconfig, utilmacros, python
, mesa, libX11, cmake
}:

stdenv.mkDerivation rec {
  name = "epoxy-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    repo = "libepoxy";
    owner = "wavewave";
    rev = "fc188b06dc350d7adbec07b1bdf51759e4d6f3b8";
    sha256 = "1kyj6p05638miyy5mf0czgvfdavgp7yn39armbigw57s75m9yczw";
  
    #owner = "anholt";
    #rev = "v${version}";
    #sha256 = "0dfkd4xbp7v5gwsf6qwaraz54yzizf3lj5ymyc0msjn0adq3j5yl";

    #owner = "yaronct";    
    #rev = "c342cba2a1b882f30b1864b5819bdb8986f5ee9c";
    #sha256 = "1v5dlzycx6bj47b7nyqz3xx8cvz1hvx2iflbx9mrfifd1w396mb4";
    
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ cmake pkgconfig utilmacros python ]; #autoreconfHook
  buildInputs = [ mesa libX11 ];

  cmakeConfigureFlags = [ "-DEPOXY_SUPPORT_EGL=False" "-DEPOXY_SUPPORT_GLX=True" "-DEPOXY_SUPPORT_WGL=False" ]; 
  #preConfigure = stdenv.lib.optional stdenv.isDarwin ''
  #  substituteInPlace configure --replace build_glx=no build_glx=yes
  #  substituteInPlace include/epoxy/config.h --replace "EPOXY_SUPPORT_EGL 1" "EPOXY_SUPPORT_EGL 0"
  #  substituteInPlace include/epoxy/config.h --replace "EPOXY_SUPPORT_GLX 0" "EPOXY_SUPPORT_GLX 1"
  #'';
    #substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  
    #substituteInPlace configure --replace build_egl=no build_egl=yes    

  #CFLAGS="-UEPOXY_SUPPORT_WGL -UEPOXY_SUPPORT_EGL -DEPOXY_SUPPORT_GLX";

  meta = with stdenv.lib; {
    description = "A library for handling OpenGL function pointer management";
    homepage = https://github.com/anholt/libepoxy;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
