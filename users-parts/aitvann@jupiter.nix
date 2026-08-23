{
  inputs,
  withSystem,
  ...
}: {
  flake.modules.nixos."aitvann@jupiter" = {...}: {
    imports = with inputs.self.modules.nixos; [
      inputs.home-manager.nixosModules.home-manager

      jupiter-host
    ];

    users.users.aitvann = {
      isNormalUser = true;
      description = "Ivan";
      extraGroups = ["networkmanager" "wheel" "docker" "homelab"];
      initialPassword = "nopassword";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrdvYCqDinFcc6ut8ALACZZcd+PBpAZ0CuB7dpmMneFvsvknftu/uGmZP1wNlTm3AGpYr6TWpD2TFvzkMs3H9cHqECL8o6gxbMWmpKMAwh2vah3QFcHSiGzqRbqOUVafjK4HI3rDO4tX4YmZrnjypZZ9UevJ8SQpz76iub3ON97mKBRBlaP4haHEF8Ft8ZJDgEEds0g81T6rlODvFnxcGCsoKhjnszpRbRfpv2WKZa7H0Xj3Ryl8evmtKxOMeotjm4I3qlbGNS2RmH6bOU0nTS+dUaYHbJwHxzijjTnKqhCUnupXiO0rJaE5Jd7g9qoqhbMtGS1gSqGjzYpg30npQoqXXzH7OYPaveRcQP7V/z8knnzBeOQcMp7gcUnp9fE8b3SayP8Le8aE1kVBLSPLEUVofJtLh2YydbunmnimNrv5h2UdDWna+ocoTDJzmBG1Ao+4Pu7SKcpxLVdSNwcQaF9edT4ja4+hrNKd6MY0leFWFu3GeR2RGznZXXGY/YRYZakj49Nf9Z/p8NUkeS9ZG64MI0I45GXbXWWr+aXxwlffohaZ9by0ql60/fZXv0Rv+HUTxe5VFp15HD9BgUx9RR+qtiq+yS4XfNF21s9Jw7045QvWCzogDprn6BSA7EKEUEoaq4Bz881FTFVg5Bz1AbEc47simG193FEd0+x2UIEw== (none)"
      ];
    };

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      users.aitvann.imports = [inputs.self.modules.homeManager."aitvann@jupiter"];
    };

    system.stateVersion = "22.05";
  };

  flake.modules.homeManager."aitvann@jupiter" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      remote-admin
    ];

    home.username = "aitvann";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "22.05";
  };

  flake.homeConfigurations."aitvann@jupiter" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem "x86_64-linux" ({pkgs, ...}: pkgs);
    modules = [inputs.self.modules.homeManager."aitvann@jupiter"];
  };
}
