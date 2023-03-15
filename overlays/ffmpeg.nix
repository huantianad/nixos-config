final: prev: {
  ffmpeg_5 = prev.ffmpeg_5.overrideAttrs (old: {
    postFixup = ''
      addOpenGLRunpath ${placeholder "lib"}/lib/libavcodec.so
      addOpenGLRunpath ${placeholder "lib"}/lib/libavutil.so
    '';
  });
  ffmpeg_5-full = prev.ffmpeg_5-full.overrideAttrs (old: {
    postFixup = ''
      addOpenGLRunpath ${placeholder "lib"}/lib/libavcodec.so
      addOpenGLRunpath ${placeholder "lib"}/lib/libavutil.so
    '';
  });
}
