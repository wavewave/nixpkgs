{ stdenv, fetchurl, python, buildPythonPackage, six, scipy
, cudnnSupport ? false
, cudnn ? null
, cudatoolkit
}:

buildPythonPackage rec {
  name = "theano-0.8.2";

  src = fetchurl {
    url = "https://pypi.python.org/packages/30/3d/2354fac96ca9594b755ec22d91133522a7db0caa0877165a522337d0ed73/Theano-0.8.2.tar.gz";
    sha256 = "0c49mz3bg57vigkyfz3yd6302587hsikhvgkh7w7ny0sxpvwhqvl";
  };
  
  buildInputs = [ python stdenv six scipy ]
                ++ (if cudnnSupport then [ cudatoolkit cudnn ] else []);

  propagatedBuildInputs = [ six scipy ]
                          ++ (if cudnnSupport then [ cudatoolkit cudnn ] else []);

  meta = with stdenv.lib; {
    description = "Optimizing compiler for evaluating mathematical expressions on CPUs and GPUs";
    homepage    = "http://deeplearning.net/software/theano";
    maintainers = with maintainers; [ ianwookim ];
    platforms   = platforms.unix;
  };
}
