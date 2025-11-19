(each [_ path (ipairs (vim.api.nvim_get_runtime_file "lsp/*.fnl" true))]
  (let [name (vim.fn.fnamemodify path ":t:r")
        (config hit) (vim.g.fennel_loader path)]
    (when (= :table (type config))
      (vim.lsp.config name config)
      (vim.lsp.enable name))
    (vim.g.fennel_log "lsp" path (.. "(" hit ")"))))
