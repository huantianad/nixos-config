{ lib, stdenv, fetchurl, p7zip, makeDesktopItem, jdk8 }:

stdenv.mkDerivation rec {
  name = "xmage";
  version = "1.4.51-dev_2022-12-19_08-39";

  src = fetchurl {
    url = "http://xmage.today/files/mage-full_${version}.zip";
    sha256 = "sha256-UkhspPhTzJwIApvFqSWQgtNCz60wmRWO7ARQdP3qJeY=";
  };

  # Use p7zip to extract because of weird unicode deck names.
  unpackPhase = ''
    runHook preUnpack
    ${p7zip}/bin/7z x -y $src
    runHook postUnpack
  '';

  desktopFile = makeDesktopItem {
    name = "xmage";
    desktopName = "XMage";
    exec = "xmage";
    icon = "xmage";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -rv ./* $out

    cat << EOF > $out/bin/xmage
    cd /home/huantian/Games/xmage && exec ${jdk8}/bin/java -Xms1G -Xmx2G -Dfile.encoding=UTF-8 -jar $out/xmage/mage-client/lib/mage-client-1.4.50.jar
    EOF
    chmod +x $out/bin/xmage
  '';

  meta = with lib; {
    description = "Magic Another Game Engine";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    homepage = "http://xmage.de/";
  };
}
