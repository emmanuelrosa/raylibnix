{ stdenv
, lib
, fetchFromGitHub
, cmake
, fetchpatch
, symlinkJoin
, mesa
, libGLU
, glfw
, libX11
, libXi
, libXcursor
, libXrandr
, libXinerama
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsa-lib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, sharedLib ? true
, includeEverything ? true
, raylib-games
, darwin
}:
let
  inherit (darwin.apple_sdk.frameworks) Carbon Cocoa OpenGL;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "raylib";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = "raylib";
    rev = finalAttrs.version;
    hash = "sha256-gEstNs3huQ1uikVXOW4uoYnIDr5l8O9jgZRTX1mkRww=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ glfw ]
    ++ lib.optionals stdenv.isLinux [ mesa libXi libXcursor libXrandr libXinerama ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio;

  propagatedBuildInputs = lib.optionals stdenv.isLinux [ libGLU libX11 ]
    ++ lib.optionals stdenv.isDarwin [ OpenGL ];

  # On Linux, a path is created for the ALSA and PulseAudio libraries.
  # This path is then patched into miniaudio.h so that it can find the libraries.
  env.linuxAudioLibs = symlinkJoin {
    name = "raylib-linux-audio-libs";
    paths = []
      ++ lib.optional alsaSupport "${alsa-lib}/lib"
      ++ lib.optional pulseSupport "${libpulseaudio}/lib";
  };

  # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
  cmakeFlags = [
    "-DUSE_EXTERNAL_GLFW=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DCUSTOMIZE_BUILD=1"
  ] ++ lib.optional includeEverything "-DINCLUDE_EVERYTHING=ON"
  ++ lib.optional sharedLib "-DBUILD_SHARED_LIBS=ON";

  passthru.tests = [ raylib-games ];

  patches = [
    # Patch version in CMakeLists.txt to 5.0.0
    # The library author doesn't use cmake, so when updating this package please
    # check that the resulting library extension matches the version
    # and remove/update this patch (resulting library name should match
    # libraylib.so.${finalAttrs.version}
    (fetchpatch {
      url = "https://github.com/raysan5/raylib/commit/032cc497ca5aaca862dc926a93c2a45ed8017737.patch";
      hash = "sha256-qsX5AwyQaGoRsbdszOO7tUF9dR+AkEFi4ebNkBVHNEY=";
    })
       # Patch miniaudio.h so that dlopen() is called with an absolute path.
       # to libpulse and libasound. However, the patch uses an environment variable
       # which is resolved in preConfigure.
  ] ++ lib.optional (alsaSupport || pulseSupport) ./miniaudio.patch;

  preConfigure = ''
    # Resolve the absolute path to ALSA and/or PulseAudio which was patched in as an environment variable.
    ${lib.optionalString (alsaSupport || pulseSupport) "substituteAllInPlace src/external/miniaudio.h"}
  '';

  meta = with lib; {
    description = "Simple and easy-to-use library to enjoy videogames programming";
    homepage = "https://www.raylib.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ adamlwgriffiths ];
    platforms = platforms.all;
    changelog = "https://github.com/raysan5/raylib/blob/${finalAttrs.version}/CHANGELOG";
  };
})
