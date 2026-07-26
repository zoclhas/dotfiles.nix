{ appimageTools, lib }:

let
  pname = "Cider";
  version = "4.1.0";
  src = /home/zoc/.local/share/nix-appimages/Cider.AppImage; # Proprietory =(

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/Cider.desktop \
      $out/share/applications/${pname}.desktop
    install -Dm444 ${appimageContents}/Cider.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=Cider %U' 'Exec=${pname} --no-sandbox %U'
  '';

  extraArgs = [ "--no-sandbox" ];
}
