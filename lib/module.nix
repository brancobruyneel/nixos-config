{ lib }:
{
  mkOpt =
    type: default: description:
    lib.mkOption { inherit type default description; };

  mkBoolOpt =
    default: description:
    lib.mkOption {
      type = lib.types.bool;
      inherit default description;
    };

  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };
}
