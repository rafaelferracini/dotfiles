return {
  "folke/which-key.nvim",
  -- O event "VeryLazy" garante que ele carregue sem atrasar a inicialização do editor
  event = "VeryLazy",
  init = function()
    -- O tempo que o Neovim espera (em milissegundos) antes de mostrar o menu
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      -- Aqui você pode customizar a aparência da janela flutuante, se desejar
    })

    -- (Opcional) Nomear os grupos de atalhos para organizar o menu
    wk.add({
      { "<leader>f", group = "Busca/Telescope/Formatar" },
      { "<leader>l", group = "LSP/LazyGit" },
      { "<leader>s", group = "Pesquisa" },
    })
  end,
}
