{ lib, stdenv, fetchzip, nukeReferences, bc, kernel }:

stdenv.mkDerivation rec {
  pname = "yt6801";
  version = "1.0.29";
  name = "${pname}-${version}-${kernel.version}";

  src = fetchzip {
    url = "https://www.motor-comm.com/Public/Uploads/uploadfile/files/20240812/yt6801-linux-driver-${version}.zip";
    sha256 = "sha256-oz6CeOUN6QWKXxe3WUZljhGDTFArsknjzBuQ4IchGeU=";
    stripRoot = false;
  };

  patches = [ "./src_makefile.patch" ];

  hardeningDisable = [ "pic" "format" ];
  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}";
  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  preBuild = "cd src";
  buildFlags = [ "modules" ];

  patchPhase = ''
    substituteInPlace ./src/Makefile \
      --replace-fail 'KSRC_BASE = /lib/modules/$(shell uname -r)' "KSRC_BASE = ${KERNELDIR}"
  '';
  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  INSTALL_MOD_PATH = placeholder "out";
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Motorcomm yt6801 Network Interface Card (NIC) driver";
    homepage = "https://www.motor-comm.com/product/ethernet-control-chip";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bartvdbraak ];
  };
}
