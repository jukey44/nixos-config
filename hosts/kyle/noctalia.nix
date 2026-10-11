{ config, pkgs, inputs, ... }:
{
   imports = [
    inputs.noctalia.nixosModules.default  # ← this defines programs.noctalia
  ];
  
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };
}   
