{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "yt6801";
  version = "1.0.29";

  src = fetchFromGitHub {
    owner = "bartvdbraak";
    repo = pname;
    rev = "ea9c2d01c0f2a4171a774527dce4daca43e11956";
    hash = "sha256-oz6CeOUN6QWKXxe3WUZljhGDTFArsknjzBuQ4IchGeU=";
  };

  nativeBuildInputs = [ bc nukeReferences ] ++ kernel.moduleBuildDependencies;
  buildInputs = [ kernel.dev ];
  hardeningDisable = [ "pic" "format" ];

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "EXTRA_CFLAGS=-Wall -I${kernel.dev}/include"
  ];

  postPatch = ''
    substituteInPlace ./yt_nic_install.sh \
      --replace-quiet "/lib/modules" "$out/lib/modules/${kernel.modDirVersion}" \
      --replace-quiet "/sbin/depmod" "# depmod"
    substituteInPlace ./src/Makefile \
      --replace-quiet "/lib/modules" "$out/lib/modules/${kernel.modDirVersion}" \
      --replace-quiet "KSRC_BASE = /lib/modules/$(shell uname -r)" \
                      "KSRC_BASE = ${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/motorcomm"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/drivers/net/ethernet/motorcomm/*.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Motorcomm yt6801 Network Interface Card (NIC) driver";
    homepage = "https://www.motor-comm.com/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bartvdbraak ];
  };
}
