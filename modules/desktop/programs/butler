{ lib, buildGoModule, fetchFromGitHub, brotli, p7zip }:

buildGoModule rec {
  name = "butler";
  version = "15.21.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "butler";
    rev = "v${version}";
    sha256 = "sha256-vciSmXR3wI3KcnC+Uz36AgI/WUfztA05MJv1InuOjJM=";
  };

  # nix-prefetch '{ sha256 }: (callPackage (import ./asdf) { }).go-modules.overrideAttrs (_: { modSha256 = sha256; })'
  vendorSha256 = "sha256-vdMu4Q/1Ami60JPPrdq5oFPc6TjmL9klZ6W+gBvfkx0=";

  buildInputs = [
    brotli
    # p7zip
  ];

  preCheck = ''
    # Skip tests that require a path to Butler
    export CI=1
  '';

  meta = with lib; {
    description = "Command-line itch.io helper.";
    homepage = "https://itchio.itch.io/butler";
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
  };
}
