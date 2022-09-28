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

  # nix-prefetch '{ sha256 }: (callPackage (import ./butler.nix) { }).
  # go-modules.overrideAttrs (_: { modSha256 = sha256; })'
  vendorSha256 = "sha256-vdMu4Q/1Ami60JPPrdq5oFPc6TjmL9klZ6W+gBvfkx0=";

  ldflags =
    let bi = "github.com/itchio/butler/buildinfo";
    in
    [
      "-X ${bi}.Version=v${version}"
      "-X ${bi}.BuiltAt=$SOURCE_DATE_EPOCH"
      # "-X ${bi}.Commit=${process.env.CI_BUILD_REF || ""}"
      "-w"
      "-s"
    ];

  buildInputs = [
    brotli
    # p7zip
  ];

  preCheck = ''
    # Skips tests that require a path to built Butler binary
    export CI=1
    # export GOFLAGS="$GOFLAGS --butlerPath='$out/bin/butler'"
    # go test -v ./butlerd/integrate --butlerPath='\$GOPATH/bin/butler'
  '';

  meta = with lib; {
    description = "Command-line itch.io helper.";
    homepage = "https://itchio.itch.io/butler";
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
  };
}
