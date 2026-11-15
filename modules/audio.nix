{ pkgs, identity, ... }:
{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # Keep Bluetooth headsets in A2DP instead of switching to the low-quality
    # call profile whenever an app opens the headset mic.
    wireplumber.extraConfig."51-bluez-no-autoswitch" = {
      "wireplumber.settings"."bluetooth.autoswitch-to-headset-profile" = false;
    };
  };
}
