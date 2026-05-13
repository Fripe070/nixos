{ pkgs, identity, ... }:
{
  # Wiki says to enable it system-wide even if already enabled in  home-manager
  programs.fish.enable = true; 
  # Bash remains our default shell for non-interactive use (so that scripts work as expected)
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [ grc ];

    programs = {
      # My shell of choice
      fish = {
        # TODO: more of https://nixos.wiki/wiki/Fish
        enable = true;
        plugins = [
          { name = "grc"; src = pkgs.fishPlugins.grc.src; }
          # Manually packaging and enable a plugin12
          #{
          #  name = "z";
          #  src = pkgs.fetchFromGitHub {
          #    owner = "jethrokuan";
          #    repo = "z";
          #    rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          #    sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          #  };
          #}
        ];
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