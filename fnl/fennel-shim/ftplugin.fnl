(let [group (vim.api.nvim_create_augroup :FennelShim {:clear false})
      pattern (if (= :boolean (type vim.g.fennel_shim_ftplugin)) [:*.fnl :*.go]
                  vim.g.fennel_shim_ftplugin)
      callback #(let [pat "ftplugin/%s.fnl ftplugin/%s/*.fnl"
                      m (?. $ :match)
                      files (if m (vim.api.nvim_get_runtime_file (pat:format m m) true) [])]
                  (each [_ f (ipairs files)] (vim.g.fennel_loader f)))]
  (vim.api.nvim_create_autocmd :FileType {: callback : group : pattern}))

