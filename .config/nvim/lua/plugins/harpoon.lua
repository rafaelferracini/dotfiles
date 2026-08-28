return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    
    -- Inicializa o plugin
    harpoon:setup()

    -- Atalho para adicionar o arquivo atual ao Harpoon
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Adicionar arquivo" })
    
    -- Atalho para abrir o menu do Harpoon
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Menu principal" })

    -- Atalhos para pular rapidamente para os arquivos 1 a 4
    vim.keymap.set("n", "1", function() harpoon:list():select(1) end, { desc = "Harpoon: Arquivo 1" })
    vim.keymap.set("n", "2", function() harpoon:list():select(2) end, { desc = "Harpoon: Arquivo 2" })
    vim.keymap.set("n", "3", function() harpoon:list():select(3) end, { desc = "Harpoon: Arquivo 3" })
    vim.keymap.set("n", "4", function() harpoon:list():select(4) end, { desc = "Harpoon: Arquivo 4" })
  end
}
