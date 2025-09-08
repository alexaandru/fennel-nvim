(local loaded-plugins {})

#(each [_ file (ipairs (vim.api.nvim_get_runtime_file (.. $ :/**/*.fnl) true))]
   (when (not (. loaded-plugins file))
     (tset loaded-plugins file true)
     (let [(resp hit) (vim.g.fennel_loader file)]
       (vim.g.fennel_log $ file (.. "(" hit ")")) resp)))
