{ mkWindowsApp
, wine
, unar
, pkgsi686Linux
, runCommand
, fetchgit
}:
let
  XGecu = fetchgit {
    url = "https://github.com/Kreeblah/XGecu_Software";
    rev = "c1c9cd86d1b81b45ae369f6000eb0267559065ae";
    deepClone = false;
    sparseCheckout = [
      "Xgpro/12"
    ];
    sha256 = "FkMva2bMjjeOWdurhlqTXK3WzmAN3PRfusu+cikdKfM=";
  };
  Xgpro = runCommand "XgproV1267" { } ''
    mkdir -p $out
    ${unar}/bin/unar ${XGecu}/Xgpro/12/xgproV1267_setup.rar -o $out
  '';
  # used for xgpro-wine compatibility
  TL866 = fetchgit {
    url = "https://github.com/radiomanV/TL866";
    rev = "2cbb2bb8cfe753b6f1a53a2185e7d2e5dc2897e3";
    deepClone = false;
    sha256 = "gH7bLCoi4wse7PIQK3A/SdNQC3abWTYLeQkouTih1eQ=";
  };
in
mkWindowsApp rec {
  pname = "xgpro";
  version = "1267";
  inherit wine;
  src = "${Xgpro}";
  winAppInstall = ''
    wine ${src}/XgproV1267_Setup.exe /S /DC:\\Xgpro
    cp ${TL866}/wine/setupapi.dll $WINEPREFIX/drive_c/windows/system32/
  '';
  winAppRun = with pkgsi686Linux; ''
    export LD_LIBRARY_PATH=${systemd}/lib:${libusb}/lib
    wine "$WINEPREFIX/drive_c/Xgpro/Xgpro.exe" "$ARGS"
  '';
  installPhase = ''
    runHook preInstall
    ln -s $out/bin/.launcher $out/bin/xgpro
    runHook postInstall
  '';
}
