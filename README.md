# fennel-nvim

Yet another [Fennel](https://fennel-lang.org/) shim for [Neovim](https://neovim.io/).

## Description

A tiny(iest?) Fennel shim.

I was really curious to see what does it take to do it, specifically: what
is the least amount of work you needed to do.

That, and I wanted to write it in Fennel itself, as much as possible 😎

Inspired by [Moonwalk](https://github.com/gpanders/nvim-moonwalk).

### Design

It adds a fennel loader to `package.loaders` and it hooks up to `SourceCmd` for
`*.fnl` so it can resolve `:source` and `:runtime` commands.
It also adds a bytecode caching layer on top of that. That's it.

## Usage

Get it in your `rtp` "somehow" (use your plugin manager, git clone it, whatever)
and then load it before you attempt to run any `.fnl` code. You can see an example
of being used [here](https://github.com/alexaandru/nvim-config/blob/master/init.vim).

## Status

What works:

- `require()` any `<rtp>/fnl/**/*.fnl` (from either Lua or Fennel);
- `:source` fennel scripts;
- `<rtp>[/after]/plugin/**/*.fnl` automatic loading;
- optional `<rtp>/ftplugin/*.fnl` filetype plugin loading (see below);
- all requests are logged to `stdpath("cache")/fennel-shim.log`, and the logfile
  is flushed async, every 1s;
- caching so that the fennel compile price is only paid once.

You can see it in action here, where it loads all my ~**700**LOC [config files](https://github.com/alexaandru/nvim-config),
as well as my four plugins and one colorscheme.

### LSP config auto-loading

All `<rtp>/lsp/*.fnl` LSP config files are automatically loaded & registered with `vim.lsp.config`,
same as neovim does for their \*.lua counterparts. Additionally, the LSPs that
are registered are also automatically enabled, as a convenience.

### Ftplugin support

Support for ftplugin is disabled by default as it is costly. You can enable it
by setting `vim.g.fennel_shim_ftplugin` to either true or any valid pattern
for `autocmd` (see `:he {aupat}`).

### Colorscheme support

The `:colorscheme` command is hardwired to look for `colors/<colorscheme>.{vim,lua}`
which obviously excludes .fnl files. There is also no event similar to `SourceCmd`
to hook up to. That means one line of _lua_ code is required, to load the rest of the
_fennel_ color scheme. See [froggy](https://github.com/alexaandru/froggy) for an example.

## Similar Projects

- [Hotpot](https://github.com/rktjmp/hotpot.nvim);
- [Moonwalk](https://github.com/gpanders/nvim-moonwalk);
- [Tangerine](https://github.com/udayvir-singh/tangerine.nvim);
- [Aniseed](https://github.com/Olical/aniseed).
