{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  sqlite,
  openssl,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "arti";
  version = "1.3.2";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    rev = "arti-v${version}";
    hash = "sha256-vypPQjTr3FsAz1AyS1J67MF35+HzMLNu5B9wkkEI30A=";
  };

  cargoHash = "sha256-XhEHjF5M7KL5qzbaoFVZtRAb1uHoZwS7W7CLXb5gO+k=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs =
    [ sqlite ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreServices
      ]
    );

  cargoBuildFlags = [
    "--package"
    "arti"
  ];

  cargoTestFlags = [
    "--package"
    "arti"
  ];

  checkFlags = [
    # problematic test that hangs the build
    "--skip=reload_cfg::test::watch_multiple"
  ];

  meta = {
    description = "Implementation of Tor in Rust";
    mainProgram = "arti";
    homepage = "https://arti.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ rapiteanu ];
  };
}
