{ lib, stdenv, fetchurl, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "yt6801-driver";
  version = "${kernel.version}-unstable-2024-10-25";

  src = fetchurl {
    url = "https://www.motor-comm.com/Public/Uploads/uploadfile/files/20240812/yt6801-linux-driver-1.0.29.zip";
    sha256 = "1r8r463y140vrkilkciba16864cfcm35kdqpby50bs8dwmw84gm3";
  };

  nativeBuildInputs = [ stdenv.lib.makeWrapper bc nukeReferences ] ++ kernel.moduleBuildDependencies;
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
