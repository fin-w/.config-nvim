1. When in fugitive (and other places like a terminal tab) the CWD argument for
   `fzf-lua` plugin in keymaps.lua `function() fzf.git_branches({ cwd =
   vim.fn.expand('%:p:h') }) end` cannot be parsed as a filepath. We need to
   pass a valid filepath: perhaps save the last valid filepath?
2. The filename defaults to the long filename when Neovim first opens, there's
   a TODO about this already. It should be updated ASAP or else it should be
   displayed correctly immediately when Neovim first loads. Right now, the
   filename is updated correctly only once the buffer is switched.
3. If an `overseer` task depends on other tasks, and a sub-task fails, the
   "restart" command on `<Leader>bB` doesn't restart the task, instead it
   doesn't find a suitable task to restart.
