{
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  libGL,
  glib,
  fontconfig,
  xorg,
  dbus,
  xkeyboard_config,
  libxkbcommon,
  wayland,
  qt6,
}:
stdenv.mkDerivation {
  name = "binary-ninja";
  buildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
    libGL
    stdenv.cc.cc.lib
    glib
    fontconfig
    xorg.libXi
    xorg.libXrender
    xorg.libxcb.dev
    xorg.xcbutilwm         # libxcb-icccm.so.4
    xorg.xcbutilimage      # libxcb-image.so.0
    xorg.xcbutilkeysyms    # libxcb-keysyms.so.1
    xorg.xcbutilrenderutil # libxcb-render-util.so.0
    dbus
    libxkbcommon
    wayland
    qt6.full
  ];

  # fix: already an issue for this
  src = /home/jess/misc/binaryninja_personal_linux.zip;

  buildPhase = ":";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt
    cp -r * $out/opt
    chmod +x $out/opt/binaryninja
    makeWrapper $out/opt/binaryninja \
          $out/bin/binaryninja \
          --prefix "QT_XKB_CONFIG_ROOT" ":" "${xkeyboard_config}/share/X11/xkb"
  '';
}

