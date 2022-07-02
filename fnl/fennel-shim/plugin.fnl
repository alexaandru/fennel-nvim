(local fennel (require :fennel))
(local dt (require :fennel-shim.util))
(local seen {})
(local pat "%s/**/*.fnl")

(fn load []
  (each [_ what (ipairs [:plugin])]
    (each [_ file (ipairs (vim.fn.globpath (vim.fn.stdpath :config)
                                           (pat:format what) 1 1))]
      (table.insert seen file)
      (dt (.. "config " what " " file) fennel.dofile file))))

{: seen : load}

