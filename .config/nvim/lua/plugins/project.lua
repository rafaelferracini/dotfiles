return {
  "ahmedkhalf/project.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    -- Inicializa o plugin
    require("project_nvim").setup({
      -- Como ele identifica o que é um "projeto" (por padrão, busca a pasta .git)
      detection_methods = { "pattern" },
      patterns = { ".git", "Makefile", "package.json" },
      
      -- Ignorar pastas ocultas ou que você não quer rastrear
      ignore_lsp = {},
      exclude_dirs = {},
      show_hidden = false,
      silent_chdir = true,
    })

    -- Carrega a extensão do project.nvim dentro do seu Telescope
    require("telescope").load_extension("projects")

    -- Define o atalho <C-p> (ou outro de sua escolha) para listar os projetos
    vim.keymap.set("n", "<C-p>", "<cmd>Telescope projects<CR>", { desc = "Projetos: Alternar entre projetos" })
  end
}
