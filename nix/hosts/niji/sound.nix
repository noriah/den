{ ... }:
{
  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    extraConfig.pipewire.adjust-sample-rate = {
      "context.properties" = {
        "default.clock.rate" = 44100;
        "defautlt.allowed-rates" = [ 48000 44100 ];
        # "default.clock.quantum" = 24;
        # "default.clock.min-quantum" = 24;
        # "default.clock.max-quantum" = 24;
      };
    };
  };
}
