# vim: set tabstop=2 shiftwidth=2 softtabstop=2:
{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, raylib
, xorg
, libGL
, makeWrapper
, makeDesktopItem
, copyDesktopItems

# rguilayout uses tinyfiledialogs to present a file browser,
# when loading layout files.
# The default (I've defined) is to use zenity.
# But you can also use kdialog or yad
, dialogImplementation ? "zenity" # possible values: zenity, kdialog, or yad.
, zenity
, kdePackages
, yad
}: stdenv.mkDerivation rec {
  pname = "rguiicons";
  version = "8da29a1a724511069188f48d7e26b1b58e56e19b";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = pname;
    rev = version;
    hash = "sha256-CNLP0ttjNt5vQ9Y/jcMyzY0m81BZUl7njioCFBEz9+0=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper copyDesktopItems ];
  hardeningDisable = [ "format" ];

  buildInputs = [ raylib
                  libGL
                  xorg.libX11
                  xorg.libXrandr
                  xorg.libXi
                  xorg.libXcursor
                  xorg.libXxf86vm
                  xorg.libXinerama 
                ];

  buildPhase = ''
    runHook preBuild
    make -C src
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/${pname} $out/bin/

    ${lib.optionalString (dialogImplementation == "zenity") "wrapProgram $out/bin/${pname} --prefix PATH : ${lib.makeBinPath [ zenity ]}"}
    ${lib.optionalString (dialogImplementation == "kdialog") "wrapProgram $out/bin/${pname} --prefix PATH : ${lib.makeBinPath [ kdePackages.kdialog ]}"}
    ${lib.optionalString (dialogImplementation == "yad") "wrapProgram $out/bin/${pname} --prefix PATH : ${lib.makeBinPath [ yad ]}"}

    for n in 16 24 32 48 64 96 128 256 1024; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp logo/${pname}_$size.png $out/share/icons/hicolor/$size/apps/${pname}.png
    done;

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "rGuiIcons";
      categories = [ "Graphics" "RasterGraphics" ];
    })
  ];

  meta = with lib; {
    description = "A simple and easy-to-use raygui icons editor.";
    homepage = "https://raylibtech.itch.io/rguiicons";
    license = licenses.zlib;
    maintainers = with maintainers; [ emmanuel ];
    platforms = [ "x86_64-linux" ];
  };
}
