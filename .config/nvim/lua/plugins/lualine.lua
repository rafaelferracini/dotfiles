return {
  "nvim-lualine/lualine.nvim",
  -- O devicons é necessário para exibir os ícones das linguagens e arquivos na barra
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        -- O tema "auto" tenta se adaptar automaticamente às cores do seu colorscheme atual
        theme = "auto",
        icons_enabled = true,
        -- Separadores clássicos em formato de seta (powerline)
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- Habilita o lualine globalmente na barra inferior (ótimo para quando usar splits)
        globalstatus = true,
      },
      -- O Lualine divide a barra inferior em blocos (a, b, c na esquerda; x, y, z na direita)
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" }
      },
    })
  end
}
