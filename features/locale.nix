{...}: {
  flake.modules.nixos.locale = {...}: {
    time.timeZone = "Europe/Moscow";
    i18n.defaultLocale = "en_GB.UTF-8";
  };
}
