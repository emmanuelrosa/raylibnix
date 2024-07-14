# vim: set tabstop=2 shiftwidth=2 softtabstop=2:
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: utils.lib.eachSystem [ utils.lib.system.x86_64-linux ] (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};

      # The zenity package was recently moved out of the gnome package set.
      # Therefore, look for zenity to be either in pkgs.gnome or pkgs.
      zenity = if builtins.hasAttr "zenity" pkgs.gnome then pkgs.gnome.zenity else pkgs.zenity;
    in
    {
      packages = {
        raylib_5 = pkgs.raylib;
        raylib-games = pkgs.raylib-games;
        rguilayout = pkgs.callPackage ./pkgs/rguilayout { inherit zenity; };
        rfxgen = pkgs.callPackage ./pkgs/rfxgen { inherit zenity; };
        rguiicons = pkgs.callPackage ./pkgs/rguiicons { inherit zenity; };
      };
    }
  );
}
