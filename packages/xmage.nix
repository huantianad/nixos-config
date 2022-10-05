{ lib, stdenv, fetchurl, jdk8, unzip }:

stdenv.mkDerivation rec {
  name = "xmage";
  version = "1.4.51-dev_2022-09-30_05-18";

  src = fetchurl {
    url = "http://xmage.today/files/mage-full_${version}.zip";
    sha256 = "sha256-kgmHQvUToPSm3aXRrav9BAalYlnmvICXCcGHvrA1kkk=";
  };

  unpackPhase = ''
    ${unzip}/bin/unzip $src || echo "pain"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -rv ./* $out
    cat << EOS > $out/bin/xmage
exec ${jdk8}/bin/java -Xms1G -Xmx2G -Dfile.encoding=UTF-8 -jar $out/xmage/mage-client/lib/mage-client-1.4.50.jar
EOS
    chmod +x $out/bin/xmage
  '';

  meta = with lib; {
    description = "Magic Another Game Engine";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    homepage = "http://xmage.de/";
  };
}
