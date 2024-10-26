{ lib, stdenv, fetchFromGitHub, nukeReferences, bc, kernel }:

stdenv.mkDerivation rec {
  pname = "yt6801";
  version = "1.0.29";
  name = "${pname}-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "bartvdbraak";
    repo = pname;
    rev = version;
    sha256 = "sha256-VEBwcbJcLffIIAP+NIhjiuMkfR+PKybBDnIbxY6zBMA=";
  };

  patchPhase = ''
    substituteInPlace ./src/Makefile \
      --replace-fail 'KSRC_BASE = /lib/modules/$(shell uname -r)' "KSRC_BASE = ${KERNELDIR}"
  '';

  hardeningDisable = [ "pic" "format" ];
  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}";
  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  preBuild = "cd src";
  buildFlags = [ "modules" ];

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Motorcomm yt6801 Network Interface Card (NIC) driver";
    homepage = "https://www.motor-comm.com/product/ethernet-control-chip";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bartvdbraak ];
  };
}
