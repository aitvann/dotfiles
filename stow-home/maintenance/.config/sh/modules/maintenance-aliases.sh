# NixOS switch
alias nixos-rebuild-switch-pure="nh os switch ~/dotfiles"
alias nixos-rebuild-switch-impure="nh os switch ~/dotfiles#${HOST}-impure --impure"
# Uncomment if the above does not work
# alias nixos-rebuild-switch-pure="nixos-rebuild --sudo --flake ~/dotfiles#${HOST} switch"
# alias nixos-rebuild-switch-impure="nixos-rebuild --sudo --flake ~/dotfiles#${HOST}-impure switch --impure"
alias nixos-rebuild-switch=nixos-rebuild-switch-impure

# HomeManager switch
alias hm-rebuild-switch-pure="nh home switch ~/dotfiles"
alias hm-rebuild-switch-impure="nh home switch ~/dotfiles#${USER}@${HOST}-impure --impure"
# Uncomment if the above does not work
# alias hm-rebuild-switch-pure="home-manager build --flake ~/dotfiles#${USER}@${HOST} switch"
# alias hm-rebuild-switch-impure="home-manager --flake ~/dotfiles#${USER}@${HOST}-impure switch --impure"
alias hm-rebuild-switch=hm-rebuild-switch-impure

# REPL
alias user-repl="nh home repl ~/dotfiles"
alias host-repl="nh os repl ~/dotfiles"
