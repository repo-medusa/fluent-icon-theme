{ lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  name ? "Fluent",
  colorVariants ? [ "standard" ]
}:
let
  pname = "Fluent-icon-theme";
in
  lib.checkListOfEnum "${pname}: available color variants" [ "standard" "green" "grey" "orange" "pink" "purple" "red" "yellow" "teal" ] colorVariants
  stdenvNoCC.mkDerivation
rec {
  inherit pname;
  version = "master";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    hash = "sha256-10jmsaV67nhHdUh50CjCyZUfVL27ty18RgNNfB7p/F4=";
  };

  nativeBuildInputs = [ gtk3 jdupes ];

  buildInputs = [ hicolor-icon-theme ];

  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    ./install.sh --dest $out/share/icons \
      --name ${name} \
      ${builtins.toString colorVariants}

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fluent icon theme for linux desktops";
    homepage = "https://github.com/vinceliuice/Fluent-icon-theme";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fakelog ];
    platforms = platforms.linux;
  };
}
