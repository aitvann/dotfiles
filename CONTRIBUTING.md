NixOS configuration utilizes the Dendritic Pattern.

## Dendritic Pattern

The dendritic pattern manages configuration complexities using yet another application of the
Nixpkgs module system -- a top-level configuration. The top-level configuration facilitates the
declaration and evaluation of lower-level configurations, such as NixOS, home-manager and
nix-darwin.

In this repository, this top-level configuration is a [flake-parts](https://flake.parts/)
configuration.

In the dendritic pattern every Nix file except for the entry point flake.nix is a module of the
top-level configuration. In other words, every Nix file that isn't an entry point is a Nixpkgs
module system module that is imported directly into the evaluation of the top-level configuration.
Additionally, every top-level module:

- implements a single feature
- ...across all configurations that that feature applies to
- is at a path that serves to name that feature

When every file is a module of one kind you can import all of them recursively using `import-tree`
from flake.nix.

There are several exceptions to this rule, each with their own reasons:

1.  Package files, end with `.pkg.nix`. This way a package could be imported using `callPackage`
    pattern.
2.  Hardware configuration files, such as `_hardware-configuration.nix`. Because this is the
    output of the `nixos-generate-config` command.
3.  Disco configurations, such as `_disko.nix`. Because this is what the `disko` cli tool expects.

Package files (.pkg.nix) are excluded from automatic import with a predicate
`.filterNot (lib.hasInfix ".pkg")` for the `import-tree` function. Files starting with underscore
are excluded by `import-tree` by default.

This repository contains following collections of features:

1.  `features/` -- a collection of reusable configurations, several users and hosts could use one
    feature if they expect similar configuration.
2.  `modules/` -- a collection of reusable modules. Each module is more of a Nix library than a
    configuration.
3.  `users/` -- a collection of individual user configurations. Each feature is named after a Nix
    user it configures: `user@host`. Each configuration is in the context of a host and thus
    should delegate all configuration to features so that it's easy to define many users.
4.  `hosts/` -- a collection of host configurations. Each feature is named after a host it
    configures. These features should be as minimal as possible: hardware specifics and a list of
    every user it has. System should be configured by an admin user.

A good feature serves just one function such as configuring a browser, configuring virtualization
and so on. Also a good feature is a reusable feature meaning it could potentially be used by
multiple users and on multiple hosts or it at least should be easy to add more user/host use
cases.

Features are declared using the helper function `mkModuleOption` from `features/utils/util.nix`.
The first argument is the feature's name and the second argument is the NixOS or Home Manager
module declaration. Features are composed via
`imports = with config'.modules.homeManager; [ ... ]` or
`imports = with config'.modules.nixos; [ ... ]`. Example: `features/hyprland-shell.nix`.

## Stow Compatibility

One distinct feature of this particular repository compared to others is its compatibility with
non-Nix configuration by structuring software configuration in a GNU Stow way: inside each package
(example `stow-home/helix`) each file replicates a file structure of its target. In case of
`helix`, that means that `config.toml` resides inside `.config/helix` and the full path from the
root of the repository is `stow-home/helix/.config/helix/config.toml`.

GNU Stow is a symlink farm manager. It is used to symlink configuration files from this repository
to places where a software being configured expects them to be. Stow cli itself is only used on
hosts with no Nix whatsoever and otherwise configuration follows Stow package structure only for
compatibility reasons and is instead symlinked by Home Manager.

As much as possible, configuration should be stored inside Stow packages; this way more software
can be used on a non-Nix systems so avoid `programs.name.settings = { ... }`. Only low-level
system configuration, packaged installation and systemd service declarations may be declared using
Nix.

Features can make use of Stow packages by a number of helper functions (declared inside
`features/utils/util.nix`) by passing the package name. This repository contains three Stow
directories distinct by their targets and each having its corresponding helper function:

- `stow-home/` -- target is user's home, `~`. Configuration for software and services local to a
  single user. Helper function: `packageHomeFiles`;
- `stow-system/` -- target is `/etc/`. Configuration for system services that do not modify their
  configuration. Helper function: `packageSystemFiles`;
- `stow-service/` -- target is `/var/lib/`. Configuration for system services that want their
  configuration to be modifiable, exists because on NixOS `/etc/` is read-only. Helper function
  `packageServiceFilesCopyCommand`, this one is more involved and additionally expects a list of
  files to copy;

Inside of each Stow package lies configuration in a format native to the software it configures:
no Nix code unless some Nix tool is the software in question.

A good Stow package works outside Nix and ideally does not even mention Nix. Packages inside
`stow-home/` should be applicable for different users: no mention of specific usernames, `$USER`
should be used instead in shell scripts. But not every configuration format is as powerful as Nix
or shell scripts and user specifics are sometimes inevitable and such specifics should be
explicit, example `ssh-general`.

Another property of a good Stow package is its independence of other packages. Examples:

1.  `stow-home/terminal/.local/bin/terminal`: it spawns a new terminal without explicitly
    mentioning which one and does so by utilizing `TERMINAL` environment variable.
2.  `stow-home/environment/.config/uwsm/env`: UWSM defines session-wide environment variables for
    many other features without explicitly naming any of them. It does by utilizing dependency
    inversion principle: each feature that wants to define a session-wide environment variable
    defines a file inside `.config/uwsm/env.d/`, example
    `./stow-home/flatpak/.config/uwsm/env.d/20-flatpak`. It works thanks to the architecture of
    UWSM that automatically sources every file from `env.d` directory.

But not every tool is as easily extendable with configuration from other features as UWSM. To fix
it some work has been done:

1.  `stow-home/sh/.config/sh/.shrc` sources every file from `.config/sh/modules/`;
2.  `stow-home/nvim/.config/nvim/init.lua` loads every file from `.config/nvim/lua/modules/`;
3.  `stow-home/hypr/.config/hypr/hyprland.lua` loads every file from `.config/hypr/modules`;

Every file added to any of those `modules/` or `env.d/` directories should include its Stow
package's name of origin to avoid potential name conflicts from different packages.

When configuration of software A requires some additional configuration of software B, this
configuration should always be injected using `modules/` method as part of A's Stow package as
described above instead of modifying configuration directly inside B's Stow package.

## Nix Scope

What Nix does best is package installation. And a lot of things that could be installed by other
means are installed by Nix instead, often by means of custom modules or modifying built-in
modules:

1.  NeoVim plugins using `programs.neovim.plugins` inside `features/neovim/default.nix`, thanks to
    built-in module;
2.  NNN plugins using `programs.nnn.plugins` inside `features/nnn/default.nix`, thanks to custom
    module declared inside `modules/nnn.nix`;
3.  ZSH plugins using `programs.stow-zsh.plugins` inside `features/zsh/default.nix`, thanks to
    custom module `stow-zsh` declared inside `./modules/zsh.nix`;
4.  Tmux plugins using `programs.tmux.plugins` inside `features/tmux.nix`, thanks to custom module
    declared inside `./modules/tmux.nix`;
5.  FireFox plugins using `programs.firefox.profiles.<profile>.extensions.packages` inside
    `features/firefox/default.nix`, thanks to built-in module;
6.  Hyprland plugins using `programs.hyprland.stowPlugins` inside `features/hyprland-shell.nix`,
    thanks to modification to the built-in module inside `modules/hyprland.nix`;

Modifications to Nix packages should be done in both NixOS and Home Manager overlays via
`nixpkgs.overlays` instead of doing so in-place (like inside `.package` option).

## Shell Configuration

At the moment the primary shell is ZSH but `stow-home/zsh/.config/zsh/.zshrc` is rather minimal:
only the ZSH-specific stuff. Anything not tied to a specific shell should be configured as part of
`sh` Stow package and then sourced by other shells. This way a big portion of shell configuration
can be re-used across different shells. Configuration inside `sh` stow package must be POSIX
compliant so no Bash-isms.

Shell scripts should be POSIX compliant as well when possible.

## NeoVim configuration

Modern NeoVim (0.11+) using **built-in** APIs. Prefer the built-in `vim.lsp`, `vim.keymap`,
`vim.fs`, `vim.api`, `vim.uv`, and `vim.treesitter` APIs over legacy `vim.g`/`:lua`/runtimepath
hacks.

### Directory map

``` txt
- init.lua: entry point
- lua/: main modules (one concern per file)
- lua/lsp/: LSP
  - init.lua: capabilities, LspAttach, diagnostics, conform
  - utils.lua: resolve_capabilities / apply_handlers
  - capabilities/<cap>.lua: one file per LSP capability
  - handlers/<name>.lua: one file per vim.lsp.handlers entry
- lua/status-line/: lualine + components/
- after/ftplugin/<ft>.lua: filetype plugins
- after/lsp/<server>.lua: per-server settings (module name = server name)
- after/queries/<lang>/textobjects.scm: tree-sitter textobjects per lang
- queries/<lang>/injections.scm: tree-sitter injections per lang
```

### LSP Capability-Driven Configuration

Keymaps/features are wired to **server capabilities**, not to specific servers, so they only
activate when the server actually supports them.

- `lsp/capabilities/<name>.lua` --- filename **must equal** an LSP capability name
  (e.g. `hoverProvider`, `renameProvider`). It exports a function
  `function(capability_value, client, buffer)` that is invoked only when that capability is
  present on the attached client. See `lsp/utils.lua` → `resolve_capabilities`.
- `lsp/handlers/<name>.lua` --- exports a table `{ handler_name, handler }`; `apply_handlers`
  registers it into `vim.lsp.handlers`.
- Per-server options live in `after/lsp/<server>.lua`, exporting a table whose `settings` are
  merged into `vim.lsp.config` (e.g. `nixd.lua`, `efm.lua`).

### Toggles

`lua/toggling.lua` provides
`toggling.register({ name, initial, description, on_enable_hook, on_disable_hook })` and
`toggling.is_enabled(name)`. Use it for buffer-scoped on/off features (e.g. `fmt_on_save`,
`inlay_hints`) instead of global booleans.

### Keymap conventions

- Use `vim.keymap.set({modes}, lhs, rhs, { silent = true, desc = "..." })`. Always provide a
  `desc` (which-key surfaces it).
- `<leader>` for buffer/file actions, `g`-prefix for navigation, `gp`/`gm`/`gh` groups for window
  movement (see `general.lua`).
- Add which-key group labels with `whichkey.add(...)` for new key groups.

## XDG Base Directories

This repository tries to minimize home directory bloat by forcing software to follow XDG Base
Directory convention and it does so by defining environment variables inside
`./stow-home/environment/.config/uwsm/env.d/10-xdg`.

## Git Commits

A commit message should follow Conventional Commits style and be structured as follows:

``` txt
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The commit contains the following structural elements, to communicate intent to the consumers of
your library:

1.  **fix:** a commit of the type fix patches a bug in your codebase (this correlates with PATCH
    in Semantic Versioning).
2.  **feat:** a commit of the type feat introduces a new feature to the codebase (this correlates
    with MINOR in Semantic Versioning).
3.  types other than *fix:* and *feat:* are allowed, for example *build:*, *chore:*, *ci:*,
    *docs:*, *style:*, *refactor:*, perf:, test:, and others.

The feature name is a good candidate for `scope`. For big features such as NeoVim, scope could be
further specified with a sub-module, example `feat(neovim::lsp)`.

Commits with small unrelated changes can just be named like `update`.

NixOS update commits must be named `nixos: update`.

## Editing checklist

- Config file change → edit the file inside the right stow package.
- New plugin → add to `programs.neovim.plugins` (Nix) and/or a vendored overlay; then configure it
  under `stow-home/nvim/.config/nvim/`.
- New LSP server → add to `vim.lsp.enable` in `lsp/init.lua`; add `after/lsp/<server>.lua` for
  server-specific settings; add capability files under `lsp/capabilities/` for any
  capability-gated keymaps.
- New language textobjects → add `after/queries/<lang>/textobjects.scm`.
- Keep Nix minimal; keep the stow files as the source of truth.

## Verification

- Nix: `nix flake check`.
