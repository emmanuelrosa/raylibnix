# vim: set tabstop=2 shiftwidth=2 softtabstop=2:
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: utils.lib.eachSystem [ utils.lib.system.x86_64-linux ] (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages = {
        raylib_5 = pkgs.raylib;
        raylib-games = pkgs.raylib-games;
        rguilayout = pkgs.callPackage ./pkgs/rguilayout { 
          # The zenity package was recently moved out of the gnome package set.
          # Therefore, look for zenity to be either in pkgs.gnome or pkgs.
          inherit (if builtins.hasAttr "zenity" pkgs.gnome then pkgs.gnome else pkgs) zenity;
        };

        rfxgen = pkgs.callPackage ./pkgs/rfxgen { 
          # The zenity package was recently moved out of the gnome package set.
          # Therefore, look for zenity to be either in pkgs.gnome or pkgs.
          inherit (if builtins.hasAttr "zenity" pkgs.gnome then pkgs.gnome else pkgs) zenity;
        };

        rguiicons = pkgs.callPackage ./pkgs/rguiicons { 
          # The zenity package was recently moved out of the gnome package set.
          # Therefore, look for zenity to be either in pkgs.gnome or pkgs.
          inherit (if builtins.hasAttr "zenity" pkgs.gnome then pkgs.gnome else pkgs) zenity;
        };
      };
    }
  );
}
