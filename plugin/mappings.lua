-- Default mappings
vim.keymap.set('n', '<space>sl', require("spot.display").display_playlist)
vim.keymap.set('n', '<space>sps', require("spot.commands").play)
vim.keymap.set('n', '<space>spp', require("spot.commands").pause)
vim.keymap.set('n', '<space>spn', require("spot.commands").next)
