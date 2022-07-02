(local fennel (require :fennel))
(local dt (require :fennel-shim.util))
(local {: seen} (require :fennel-shim.plugin))
(local pat "%s/**/*.fnl")

#(each [_ what (ipairs [:after/plugin])]
   (each [_ file (ipairs (vim.api.nvim_get_runtime_file (pat:format what) true))]
     (if (not (vim.tbl_contains seen file))
         (dt (.. what " " file) fennel.dofile file))))

