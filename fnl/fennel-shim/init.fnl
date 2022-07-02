(local fennel (require :fennel))
(local cache-dir (vim.fn.stdpath :cache))
(local cache {:cache {} :last_dump 0 :ms 1000 :file (.. cache-dir :/fennel-shim.bin)})
(set vim.g.fennel_log
     (let [f (assert (io.open (.. cache-dir :/fennel-shim.log) :a))]
       (fn flush []
         (vim.defer_fn flush 1000)
         (f:flush))
       (flush)
       (fn [...]
         (f:write (string.format "[%s] %s\n" (os.date "%F %T") (table.concat [...] " "))))))

(vim.g.fennel_log :Loaded (fennel.runtimeVersion))

(fn cache.dump []
  (when (and cache.last_update (> cache.last_update cache.last_dump))
    (let [f (assert (io.open cache.file :wb))]
      (set cache.last_dump (vim.loop.hrtime))
      (assert (f:write (vim.mpack.encode cache.cache)))
      (assert (f:flush))
      (assert (f:close))
      (vim.g.fennel_log "cache saved to disk")))
  (vim.defer_fn cache.dump cache.ms))

((fn cache.restore []
   (let [f (io.open cache.file :rb)]
     (if f (let [c (f:read :*all)
                 (ok data) (pcall vim.mpack.decode c)]
             (if ok (do (set cache.cache data)
                        (vim.g.fennel_log "cache:" (length (vim.tbl_keys data)) "entries loaded"))
                 (vim.g.fennel_log "cache file corrupted, starting fresh")))))
   (vim.defer_fn cache.dump cache.ms)))

(fn cache.compile [file]
  (let [f (assert (io.open file :r))]
    (fennel.compileString (f:read :*all) {:filename file})))

(fn cache.fetch [file]
  (?. cache.cache file))

(fn cache.set [file sec]
  (let [data (cache.compile file)]
    (tset cache.cache file {: data : sec})
    (set cache.last_update (vim.loop.hrtime))
    data))

(fn cache.fetch-or-set [file]
  (let [sec (?. (vim.loop.fs_stat file) :mtime :sec)
        data (cache.fetch file)]
    (if (or (not data) (< data.sec sec))
        (values (cache.set file sec) :miss)
        (values data.data :hit))))

(fn vim.g.fennel_loader [file]
  (let [(code hit) (cache.fetch-or-set file)]
    (values ((load code)) hit)))

(fn SourceCmd [lib]
  (let [(resp hit) (vim.g.fennel_loader lib.file)
        msg (.. (or lib.msg (.. "sourced " lib.file)) " (" hit ")")]
    (vim.g.fennel_log msg) resp))

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

(table.insert package.loaders (fn [] load-lib))
