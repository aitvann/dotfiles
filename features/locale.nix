{mkModuleOption, ...}: {
  options.modules.nixos = mkModuleOption "locale" ({...}: {
    time.timeZone = "Europe/Moscow";
    i18n.defaultLocale = "en_GB.UTF-8";
  });
}
