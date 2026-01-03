final: prev: {
  vesktop = prev.vesktop.overrideAttrs {
    preBuild = ''
      cp -r ${prev.electron.dist} electron-dist
      chmod -R u+w electron-dist
    '';

    buildPhase = ''
      runHook preBuild

      pnpm build
      pnpm exec electron-builder \
        --dir \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=electron-dist \
        -c.electronVersion=${prev.electron.version}

      runHook postBuild
    '';
  };
}
