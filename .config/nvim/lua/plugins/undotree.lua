return {
  "mbbill/undotree",
  config = function()
    -- Atalho clássico para abrir/fechar a árvore de histórico
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndoTree: Alternar painel" })
  end
}
