{ pkgs, lib, identity, ... }:
{
  # Wiki says to enable it system-wide even if already enabled in  home-manager
  programs.fish.enable = true; 
  # Bash remains our default shell for non-interactive use (so that scripts work as expected)
  # but we switch to fish immediately if it is interactive
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
      fi
    '';
  };

  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [ 
      grc
      eza
     ];

    programs = {
      # My shell of choice
      fish = {
        # TODO: more of https://nixos.wiki/wiki/Fish
        enable = true;
        plugins = with pkgs; [
          { name = "grc"; src = fishPlugins.grc.src; }
          { name = "z"; src = fishPlugins.z.src; }
        ];
        interactiveShellInit = ''
        '';
        shellAliases = {
          ls = "eza -h --icons=auto --group-directories-first";
          ll = "eza -hal --icons=auto --group-directories-first";
          tree = "eza --tree --level 2 --icons=auto --group-directories-first";
        };
      };
      # Use fish for nix shells
      nix-your-shell = {
        enable = true;
        enableFishIntegration = true;
      };
      # Shell prompt
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;

        settings = {
          format = "$directory$git_branch$git_status$cmd_duration$status$character";

          directory = {
            truncation_length = 3;
            truncate_to_repo = true;
            format = "[$path]($style) ";
          };
          git_branch = {
            symbol = "";
            format = "[$branch]($style)";
          };
          git_status = {
            format = "[$all_status$ahead_behind]($style) ";
            ahead = "↑$count";
            behind = "↓$count";
            diverged = "↑$ahead_count ↓$behind_count";
          };
          cmd_duration = {
            min_time = 1000;
            format = "[$duration]($style) ";
          };
          status = {
            disabled = false;
            format = "[| $status]($style) ";
          };
        };
      };

      # Nix helper
      nh = {
        enable = true;
        flake = identity.configPath;
      };
      # z command as an improved cd
      zoxide.enable = true;

      git = {
        enable = true;
        settings = {
          user = {
            email = identity.email;
            name = identity.displayName;
          };
          init.defaultBranch = "main";
        };
      };
      gh = {
        enable = true;
        gitCredentialHelper.enable = true;
      };
    };
  };
}