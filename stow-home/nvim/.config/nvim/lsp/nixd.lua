return {
    settings = {
        nixd = {
            formatting = {
                command = { "alejandra" },
            },
            options = {
                nixos = {
                    expr =
                    '(builtins.getFlake "${builtins.getEnv "HOME"}/dotfiles").nixosConfigurations.${(import <nixpkgs> {}).lib.strings.trim (builtins.readFile "/etc/hostname")}.options',
                },
                home_manager = {
                    expr =
                    '(builtins.getFlake "${builtins.getEnv "HOME"}/dotfiles").homeConfigurations."${(import <nixpkgs> {}).lib.strings.trim (builtins.readFile "/etc/hostname")}-${builtins.getEnv "USER"}".options',
                },
            },
        },
    },
}
