{
  inputs = {
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = { self, haumea, nixpkgs }: 
  let
        loader = _: path: {
                path = builtins.dirOf path;
                description = (import path).description;
        };

        matcher = f: haumea.lib.matchers.regex "flake.nix" (_: f);

        liftFlake = _: mod:
                nixpkgs.lib.attrsets.unionOfDisjoint
                (removeAttrs mod [ "flake" ])
                (mod.flake or { });

        removeEmpty = _: mod:
                nixpkgs.lib.attrsets.filterAttrs
                (_: v: builtins.attrNames v != [])
                mod;
        
        templates = haumea.lib.load {
                src = ./src;
                loader = [(matcher loader)];
                transformer = [ removeEmpty liftFlake ];
        };
  in {
        inherit templates;
  };
}
