final: prev: {
  claude-chill = final.rustPlatform.buildRustPackage rec {
    pname = "claude-chill";
    version = "0.1.0";

    src = final.fetchFromGitHub {
      owner = "davidbeesley";
      repo = "claude-chill";
      rev = "e2b20dce1cce8b7301215bd2d8a7db943c00e7a4";
      hash = "sha256-EyhaE5fd7+pedai1Icbd3cGvF56jxW9g3+aQ6c6P8UE=";
    };

    cargoHash = "sha256-ctJp+dwb4Lcd7K9CzZ9MuIFPqFKeh1a6Hl7dP4NB+kI=";

    buildAndTestSubdir = "crates/claude-chill";

    meta = with final.lib; {
      description = "A PTY proxy that tames Claude Code's massive terminal updates";
      homepage = "https://github.com/davidbeesley/claude-chill";
      license = licenses.mit;
      mainProgram = "claude-chill";
    };
  };
}
