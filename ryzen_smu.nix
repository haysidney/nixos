{ stdenv, lib, fetchFromGitLab, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "ryzen_smu-${version}-${kernel.version}";
  version = "0.1.2";

  src = fetchFromGitLab {
    owner = "moson-mo";
    repo = "ryzen_smu";
    rev = "23c8a49e8ca7c05fb4f61d62a13ef6b962c2331f";
    sha256 = "V9GeHwAHtq6CtX9nMr4ZyFW9bBK2Xqc0MPmZEpfVxag=";
  };

  sourceRoot = "";
#  hardeningDisable = [ "pic" "format" ];                                             # 1
  nativeBuildInputs = kernel.moduleBuildDependencies;                       # 2

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"                                 # 3
    "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"    # 4
    "INSTALL_MOD_PATH=$(out)"                                               # 5
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernels/
    cp ryzen_smu.ko $out/lib/modules/${kernel.modDirVersion}/kernels/
  '';

  meta = with lib; {
    description = "Ryzen SMU";
    homepage = "https://gitlab.com/moson-mo/ryzen_smu";
#    license = licenses.gpl2;
#    maintainers = [ maintainers.makefu ];
    platforms = platforms.linux;
  };
}
