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
  hardeningDisable = [ "pic" "format" ];

  postPatch = ''
    substituteInPlace ./yt_nic_install.sh \
      --replace "/lib/modules" "$out/lib/modules" \
      --replace "/sbin/depmod" "# depmod"

    substituteInPlace ./src/Makefile \
      --replace "/lib/modules" "$out/lib/modules/${kernel.modDirVersion}" \
      --replace "kernel/drivers/net/ethernet/motorcomm" "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/motorcomm"
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    ("KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build")
    ("EXTRA_CFLAGS=-Wall -g -I${kernel.dev}/include")
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

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
