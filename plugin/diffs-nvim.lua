-- diffs.nvim set up is a bit weird, there's no setup() function. I don't much
-- like this approach but there is no alternative.
vim.g.diffs = { integrations = { fugitive = true } }
