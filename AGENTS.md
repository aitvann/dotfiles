# AGENTS.md

Guidance for AI agents working in this repository.

## What this repository is

A NixOS / Home Manager dotfiles repository built around the [Dendritic
Pattern](https://github.com/mightyiam/dendritic). The core philosophy:

- **Declarative encrypted BtrFS** via [disko](https://github.com/nix-community/disko).
- **Minimal NixOS config** --- as much as possible is pushed into Home Manager.
- **Minimal Home Manager config** --- as much as possible is configured in a [GNU
  Stow](https://www.gnu.org/software/stow/)-compatible way.
- **Minimal NeoVim config** --- prefer LSP / TreeSitter; integrate external tools (n³ file
  manager, lazygit, kitty terminal) rather than reimplementing them in-editor.

## Top-level layout

| Path | Purpose |
|-------------------------------------------------|-------------------------------------------------|
| `flake.nix` | Flake root. Uses `flake-parts`; imports `features/`, `modules/`, `hosts/`, `users/` via `import-tree`. |
| `features/` | Reusable feature modules (one dir per concern, e.g. `neovim/`, `bat.nix`, `workstation.nix`). |
| `modules/` | Shared Nix modules. |
| `hosts/` | Per-host NixOS configurations. |
| `users/` | Per-user Home Manager configurations. |
| `stow-home/` | Stow package targeting `~/`. |
| `stow-system/` | Stow package targeting `/etc/`. |
| `stow-service/` | Stow package targeting `/var/lib/`. |
| `configs/` | Miscellaneous non-stow config. |
| `secrets/` | Encrypted secrets (git-crypt). |

## The Stow compatibility pattern (critical)

Configuration files are stored as **plain files** under a *stow package* that mirrors the target
directory. Nix is only used to install packages and their plugins/extensions --- it does **not**
author the config files.

Each stow package is a directory named after the tool or a feature, e.g. `stow-home/nvim/`,
`stow-home/helix/`, `stow-system/nginx-jupiter/`. Inside it, the real dotfile tree lives:
`stow-home/nvim/.config/nvim/...`.

Instead of hand-linking every file, use the helper functions (defined in `features/utils/util.nix`
and injected into modules via `_module.args`):

- `packageHomeFiles "nvim"` → links `stow-home/nvim/**` into `~` (like `stow -t ~ -S nvim`).
- `packageSystemFiles "nginx-jupiter"` → links `stow-system/nginx-jupiter/**` into `/etc`.
- `packageServiceFilesCopyCommand "adguardhome"` → generates a `systemd` copy command for
  `stow-service/`.

Example (see `features/neovim/default.nix`):

``` nix
home.file = lib.mkMerge ([
    (packageHomeFiles "nvim")
    (packageHomeFiles "ripgrep")
]);
```

**Rules of thumb when editing:**

- To change a tool's config, edit the file inside the corresponding stow package
  (e.g. `stow-home/nvim/.config/nvim/lua/...`). Do **not** inline config into Nix.
- To add a new tool, create `stow-home/<pkg>/...` (or system/service equivalent) and add
  `packageHomeFiles "<pkg>"` to the relevant `home.file` merge.
- Do not use `programs.<tool>.settings = {...}` when a stow package already exists --- keep the
  stow file as the single source of truth.

## Nix module conventions

- Features use `mkModuleOption "<name>"` (from `features/utils/util.nix`) to declare an importable
  module option, e.g. `options.modules.homeManager = mkModuleOption "neovim" ({ ... }: { ... })`.
- Modules are composed via `imports = with config'.modules.homeManager; [ ... ]` or
  `imports = with config'.modules.nixos; [ ... ]`. `config'` is the full config, injected as
  `_module.args.config'` use it to avoid confilicts with `system` or `home` level `config` value.
- `impurity` (from [impurity.nix](https://github.com/outfoxxed/impurity.nix)) is available in
  modules and used to point store paths directly at the repo for debugging.
- Unfree packages must be listed in `nixpkgs.allowedUnfreePackages`.
- Custom/vendored plugins are added via a `nixpkgs.overlays` that extends `pkgs.vimPlugins` (see
  `features/neovim/default.nix`).

## NeoVim configuration

Modern Neovim (0.11+) using **built-in** APIs. There is **no lazy.nvim / plugin manager in the
config** --- plugins are installed by Nix (`programs.neovim.plugins` in
`features/neovim/default.nix`). Prefer the built-in `vim.lsp`, `vim.keymap`, `vim.fs`, `vim.api`,
`vim.uv`, and `vim.treesitter` APIs over legacy `vim.g`/`:lua`/runtimepath hacks.

### Entry point & load order (`init.lua`)

- `require("lang-layout")` **must be the first** line (keyboard layout remap).
- `require('langmapper').automapping({ buffer = false })` **must be the last** line (remaps Vim
  keybindings to the active layout).
- Everything else is `require(...)`'d in between, in dependency order.
- Optional user-local modules in `lua/modules/*.lua` are auto-loaded (wrapped in `pcall`). This
  directory is intentionally not in the repo.

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

### LSP: capability-driven keymaps

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
- LSP is enabled from the `DirenvLoaded` user event (see `lsp/init.lua`) so the direnv environment
  is loaded before any server starts. New servers go in the `vim.lsp.enable { ... }` list there.
- Completion capabilities come from `blink-cmp` (`blink.get_lsp_capabilities()`).

### Toggles

`lua/toggling.lua` provides
`toggling.register({ name, initial, description, on_enable_hook, on_disable_hook })` and
`toggling.is_enabled(name)`. Use it for buffer-scoped on/off features (e.g. `fmt_on_save`,
`inlay_hints`) instead of global booleans.

### Textobjects & motions

- Custom tree-sitter textobjects are defined per-language in
  `after/queries/<lang>/textobjects.scm`; setup in `plugin-treesitter.lua` (via
  `nvim-treesitter-textobjects`).
- Repeatable motions use `repeatable-move-nvim` (`repeat_move.make_repeatable_move_pair`) and
  treesitter `repeatable_move` for `;`/`,`.

### External tool integration

Prefer plugins that wrap external CLIs over reimplementing required functionality in-editor:

- **nnn** --- file manager (`<leader>e`), via `nnn-nvim` + `tmux`.
- **lazygit** --- git GUI, via `lazygit-nvim` (`lua/git.lua`).

### Keymap conventions

- Use `vim.keymap.set({modes}, lhs, rhs, { silent = true, desc = "..." })`. Always provide a
  `desc` (which-key surfaces it).
- `<leader>` for buffer/file actions, `g`-prefix for navigation, `gp`/`gm`/`gh` groups for window
  movement (see `general.lua`).
- Add which-key group labels with `whichkey.add(...)` for new key groups.

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

- Nix: `nix flake check --impure` / build the relevant host or home config.
- Test editor changes live: the repo can be pointed at directly via impurity (see README "Stow
  Compatibility" point 5) to avoid full rebuilds.
