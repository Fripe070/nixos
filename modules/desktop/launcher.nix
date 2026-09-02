{ pkgs, identity, inputs, ... }:
{
  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    imports =  [ inputs.vicinae.homeManagerModules.default ];
    programs.vicinae = {
      enable = true;
      package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
      settings = {
        close_on_focus_loss = true;
        pop_to_root_on_close = true;
        telemetry.system_info = false;
        launcher_window = {
          layer_shell = {
            enabled = true;
            keyboard_interactivity = "on_demand";
            layer = "top";
          };
        };
      };
    };
  };
}
