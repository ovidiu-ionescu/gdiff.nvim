# gdiff.nvim

A lightweight Neovim plugin to perform side-by-side Git diffs against any branch, featuring high-visibility statusline integration and automatic UI cleanup.
## ✨ Features

- Side-by-Side Comparison: Compare your current buffer with any Git branch in a vertical split.
- Intelligent Statusline: Displays the current branch on the left and the reference branch (e.g., master) on the right using Lualine.
- Branch Autocomplete: Full tab-completion for local and remote Git branches.
- Automatic Cleanup: Closing the reference window automatically turns off diff mode in the original buffer.
- Clean UI: Automatically hides line numbers and sign columns in the reference buffer to maximize code visibility.

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "ovidiu-ionescu/gdiff.nvim",
    dependencies = { "nvim-lualine/lualine.nvim" },
    config = function()
        require("gdiff").setup()
        
        -- Configure Lualine with gdiff components
        local gdiff_lualine = require("gdiff.lualine").get_sections()
        require("lualine").setup({
            sections = gdiff_lualine,
            inactive_sections = gdiff_lualine
        })
    end
}
```

## 🚀 Usage

### Commands
Command | Description
:-- | :--
`:Gdiff <branch> | Opens a vertical split comparing current file to `<branch>`.
`Gdiff` | Defaults to comparing against `master`.

### Keybindings

The plugin provides a default mapping for closing the diff view:
- `<leader>dc` : Closes the diff split and restores the original window state.

## 🛠 Configuration

If you want to integrate gdiff into your existing Lualine configuration rather than overwriting it, you can pull the components individually:

```lua
local gdiff_lualine = require('gdiff.lualine').get_sections()

require('lualine').setup({
    sections = {
        lualine_b = gdiff_sections.lualine_b, -- Branch icons/names
        lualine_c = gdiff_sections.lualine_c, -- Filename logic (hides on right)
        -- ... your other sections
    }
})
```

## ⌨️ Requirements
- Neovim 0.8+
- Git installed in your system path.
- [Nerd Fonts](https://www.nerdfonts.com/) (optional, for branch icons).







