(local fennel (require :fennel))
(local dt (require :fennel-shim.util))

(fn SourceCmd [lib]
  (local msg (or lib.msg (.. "sourced " lib.file)))
  (dt msg fennel.dofile lib.file))

(fn loader-glob [basename]
  (let [name (basename:gsub "%." "/")
        pat "fnl/**/%s/init.fnl fnl/**/%s.fnl"]
    (pat:format name name)))

(fn load-lib [basename]
  (let [pat (loader-glob basename)
        [file] (vim.api.nvim_get_runtime_file pat false)
        msg (.. "required " basename " from " (or file ""))
        err (.. ": module '" basename "' not found")]
    (if file (SourceCmd {: file : msg}) (error err))))

(let [aug #(vim.api.nvim_create_augroup $ {:clear true})
      au vim.api.nvim_create_autocmd
      group (aug :FennelShim)]
  (au :SourceCmd {:callback SourceCmd :pattern :*.fnl : group}))

(fn fennel-loader []
  load-lib)

(table.insert package.loaders fennel-loader)

