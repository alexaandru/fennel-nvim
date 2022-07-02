# fennel-nvim

Fennel shim for Neovim.

## Description

This is a toy/experiment. I was really curious to see what does it take to
do it, specifically: what is the least amount of work you need to do.

That, and I wanted to write it in Fennel itself, as much as possible 😎

## Status

It currently loads all my ~650LOC [config files](https://github.com/alexaandru/nvim-config),
as well as my three plugins and one colorscheme.

What works:

- `require()` any `<rtp>/fnl/**/*.fnl` (from either Lua or Fennel);
- `:source` fennel scripts;
- `<rtp>/plugin/**/*.fnl` automatic loading, **AFTER** Vim and Lua files are processed
  (the .fnl files are loaded from the shim's own after/plugin hook);
- all requests are logged to `stdpath("cache")/fennel-shim.log`, and the logfile
  is flushed async, every 1s.

What might be added:

- support for loading .fnl files from other places .lua files can be loaded from
  (ftplugin, compiler, syntax, etc.);
- some form of caching.

### Colorscheme

Unfortunately `:colorscheme` is hardwired to look for `colors/<colorscheme>.{vim,lua}`
which obviously excludes .fnl files. There is also no event similar to `SourceCmd`
to hook up to. That means one line of lua code is required, to load the rest of the
fennel color scheme. See [froggy](https://github.com/alexaandru/froggy) for an example.

### Benchmark

It is 1.6 times slower than Hotpot. Benchmark was done by running
`nvim --startuptime x +q` 10 times for each. I got a 196ms avg. startup time
with Hotpot and 321ms with this shim.

At the same time it is only a little over 100LOC, not counting blank lines,
vs. +6KLOC for Hotpot.

## Use

... it at your own risk :-) There is [Hotpot](https://github.com/rktjmp/hotpot.nvim)
which I've been using myself for about a year now and there's also [Moonwalk](https://github.com/gpanders/nvim-moonwalk)
which is what inspired this plugin.

If you do insist on trying it out, clone it in your `rtp` somewhere and then
load it before you attempt to run any .fnl code. You can see an example of
being used [here](https://github.com/alexaandru/nvim-config).
