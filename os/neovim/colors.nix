{
  foreground,
  background,
  identifier,
  type,
  literal,
  keyword,
  comment,
}:

''
  -- Default
  vim.api.nvim_set_hl(0, "Normal", { fg = "#${foreground}", bg = "#${background}" })

  -- Identifier
  vim.api.nvim_set_hl(0, "Identifier", { fg = "#${identifier}" })
  vim.api.nvim_set_hl(0, "@variable", { fg = "#${identifier}" })
  vim.api.nvim_set_hl(0, "Function", { fg = "#${identifier}" })

  -- Comment
  vim.api.nvim_set_hl(0, "Comment", { fg = "#${comment}" })

  -- Literal
  vim.api.nvim_set_hl(0, "String", { fg = "#${literal}" })
  vim.api.nvim_set_hl(0, "Constant", { fg = "#${literal}" })

  -- Type
  vim.api.nvim_set_hl(0, "Type", { fg = "#${type}" })
  vim.api.nvim_set_hl(0, "Special", { fg = "#${type}" })

  -- Keyword
  vim.api.nvim_set_hl(0, "Statement", { fg = "#${keyword}" })
''
