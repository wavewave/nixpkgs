{ stdenv, requireFile, cudatoolkit65 }:

stdenv.mkDerivation rec {
  version = "2";

  name = "cudnn-${version}";

  src = requireFile rec {
    name = "cudnn-6.5-linux-x64-v${version}.tgz";
    message = '' 
      This nix expression requires that ${name} is
      already part of the store. Register yourself to NVIDIA Accelerated Computing Developer Program
      and download cuDNN library at https://developer.nvidia.com/cudnn, and store it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    sha256 = "1al0ydanlqhfk1pb98giz495lb1yylrfaczzpxipz9fzz5mwn0jb";

  };

  phases = "unpackPhase installPhase fixupPhase";

  propagatedBuildInputs = [ cudatoolkit65 ];

  installPhase = ''
    mkdir -p $out
    mkdir -p $out/include
    mkdir -p $out/lib64
    mkdir -p $out/share/doc
    cp -a cudnn.h $out/include
    cp -a libcudnn* $out/lib64
    cp -a CUDNN_License.pdf INSTALL.txt $out/share/doc
  '';

  # all binaries are already stripped
  #dontStrip = true;

  # we did this in prefixup already
  #dontPatchELF = true;

  meta = {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = stdenv.lib.licenses.unfree;
  };
}
