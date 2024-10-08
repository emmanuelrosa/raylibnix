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
        rguilayout = pkgs.callPackage ./pkgs/rguilayout { };
        rfxgen = pkgs.callPackage ./pkgs/rfxgen { };
        rguiicons = pkgs.callPackage ./pkgs/rguiicons { };
        riconpacker = pkgs.callPackage ./pkgs/riconpacker { };
        raylib-games = pkgs.raylib-games;
      };
    }
  );
}
