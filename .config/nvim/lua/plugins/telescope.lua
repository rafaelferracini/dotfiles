return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8', -- ou branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')

    -- Mapeamentos básicos locais do plugin (opcional, se preferir centralizar tudo)
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Project File' })
    vim.keymap.set('n', '<C-f>', builtin.git_files, { desc = 'Only Git Project File' })
    vim.keymap.set('n', '<leader>fs', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") });
	end)
    vim.keymap.set('n', '<leader>fc', function ()
      builtin.find_files({
        cwd = vim.fn.stdpath("config")
      })
    end, { desc = "Telescope: Arquivos de configuração" })
end
}
