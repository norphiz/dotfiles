vim.o.fillchars="eob: "

if vim.o.diff == true then
    vim.o.cursorline=0
end

if vim.o.term ~= "linux" then
    vim.o.termguicolors=1
end

vim.api.nvim_set_hl(0, "Tag", {})
vim.api.nvim_set_hl(0, "Debug", {})
vim.api.nvim_set_hl(0, "Ignore", {})
vim.api.nvim_set_hl(0, "Conceal", {})
vim.api.nvim_set_hl(0, "ModeMsg", {})
vim.api.nvim_set_hl(0, "MsgArea", {})
vim.api.nvim_set_hl(0, "MoreMsg", {})
vim.api.nvim_set_hl(0, "CursorIM", {})
vim.api.nvim_set_hl(0, "NormalNC", {})
vim.api.nvim_set_hl(0, "CurSearch", {})
vim.api.nvim_set_hl(0, "FoldColumn", {})
vim.api.nvim_set_hl(0, "SignColumn", {})
vim.api.nvim_set_hl(0, "CursorLine", {})
vim.api.nvim_set_hl(0, "TabLineFill", {})
vim.api.nvim_set_hl(0, "TermCursorNC", {})
vim.api.nvim_set_hl(0, "Todo", {link="Macro"})
vim.api.nvim_set_hl(0, "Label", {link="Macro"})
vim.api.nvim_set_hl(0, "Float", {link="Number"})
vim.api.nvim_set_hl(0, "Define", {link="Macro"})
vim.api.nvim_set_hl(0, "PreProc", {link="Type"})
vim.api.nvim_set_hl(0, "Repeat", {link="Macro"})
vim.api.nvim_set_hl(0, "Typedef", {link="Type"})
vim.api.nvim_set_hl(0, "Title", {link="String"})
vim.api.nvim_set_hl(0, "Error", {link="Keyword"})
vim.api.nvim_set_hl(0, "Folded", {link="LineNr"})
vim.api.nvim_set_hl(0, "debugPC", {link="Pmenu"})
vim.api.nvim_set_hl(0, "Boolean", {link="Number"})
vim.api.nvim_set_hl(0, "DiffAdd", {link="String"})
vim.api.nvim_set_hl(0, "Operator", {link="Macro"})
vim.api.nvim_set_hl(0, "PreCondit", {link="Type"})
vim.api.nvim_set_hl(0, "Structure", {link="Type"})
vim.api.nvim_set_hl(0, "Folded", {link="Comment"})
vim.api.nvim_set_hl(0, "Question", {link="Macro"})
vim.api.nvim_set_hl(0, "SpellCap", {link="Number"})
vim.api.nvim_set_hl(0, "WarningMsg", {link="Type"})
vim.api.nvim_set_hl(0, "DiffChange", {link="Type"})
vim.api.nvim_set_hl(0, "Exception", {link="Macro"})
vim.api.nvim_set_hl(0, "Include", {link="Special"})
vim.api.nvim_set_hl(0, "NonText", {link="Comment"})
vim.api.nvim_set_hl(0, "PmenuKind", {link="Pmenu"})
vim.api.nvim_set_hl(0, "PmenuSbar", {bg="#5c6370"})
vim.api.nvim_set_hl(0, "Statement", {link="Macro"})
vim.api.nvim_set_hl(0, "WildMenu", {link="Cursor"})
vim.api.nvim_set_hl(0, "VisualNOS", {link="Pmenu"})
vim.api.nvim_set_hl(0, "SpellRare", {link="Number"})
vim.api.nvim_set_hl(0, "Character", {link="String"})
vim.api.nvim_set_hl(0, "Function", {link="Special"})
vim.api.nvim_set_hl(0, "PmenuExtra", {link="Pmenu"})
vim.api.nvim_set_hl(0, "PmenuThumb", {bg="#dfe5f2"})
vim.api.nvim_set_hl(0, "FloatTitle", {link="Title"})
vim.api.nvim_set_hl(0, "ErrorMsg", {link="Keyword"})
vim.api.nvim_set_hl(0, "SpellLocal", {link="Number"})
vim.api.nvim_set_hl(0, "Conditional", {link="Macro"})
vim.api.nvim_set_hl(0, "StorageClass", {link="Type"})
vim.api.nvim_set_hl(0, "Substitute", {link="Search"})
vim.api.nvim_set_hl(0, "Special", {link="Directory"})
vim.api.nvim_set_hl(0, "DiffDelete", {link="Keyword"})
vim.api.nvim_set_hl(0, "Identifier", {link="Keyword"})
vim.api.nvim_set_hl(0, "SpecialKey", {link="Comment"})
vim.api.nvim_set_hl(0, "LineNrAbove", {link="LineNr"})
vim.api.nvim_set_hl(0, "LineNrBelow", {link="LineNr"})
vim.api.nvim_set_hl(0, "CursorColumn", {link="Pmenu"})
vim.api.nvim_set_hl(0, "WinSeparator", {link="LineNr"})
vim.api.nvim_set_hl(0, "Delimiter", {link="Directory"})
vim.api.nvim_set_hl(0, "TabLineSel", {link="PmenuSel"})
vim.api.nvim_set_hl(0, "SpecialChar", {link="Directory"})
vim.api.nvim_set_hl(0, "PmenuKindSel", {link="PmenuSel"})
vim.api.nvim_set_hl(0, "PmenuExtraSel", {link="PmenuSel"})
vim.api.nvim_set_hl(0, "StatusLineNC", {link="StatusLine"})
vim.api.nvim_set_hl(0, "debugBreakpoint", {link="PmenuSel"})
vim.api.nvim_set_hl(0, "ColorColumn", {link="CursorColumn"})
vim.api.nvim_set_hl(0, "Normal", {fg="#dfe5f2", bg="#21242b"})
vim.api.nvim_set_hl(0, "StatusLineTermNC", {link="StatusLine"})
vim.api.nvim_set_hl(0, "Keyword", {fg="#ff6e7a", ctermfg="Red"})
vim.api.nvim_set_hl(0, "Pmenu", {bg="#3e4452", ctermbg="Black"})
vim.api.nvim_set_hl(0, "Type", {fg="#ffd587", ctermfg="Yellow"})
vim.api.nvim_set_hl(0, "LineNr", {fg="#5c6370", ctermfg="Gray"})
vim.api.nvim_set_hl(0, "String", {fg="#c0fa96", ctermfg="Green"})
vim.api.nvim_set_hl(0, "Comment", {fg="#5c6370", ctermfg="Gray"})
vim.api.nvim_set_hl(0, "Number", {fg="#d19a66", ctermfg="Yellow"})
vim.api.nvim_set_hl(0, "Constant", {fg="#66deed", ctermfg="Cyan"})
vim.api.nvim_set_hl(0, "Macro", {fg="#e387ff", ctermfg="Magenta"})
vim.api.nvim_set_hl(0, "Directory", {fg="#6ebeff", ctermfg="Blue"})
vim.api.nvim_set_hl(0, "DiffText", {fg="#dfe5f2", ctermfg="White"})
vim.api.nvim_set_hl(0, "CursorLineNr", {fg="#dfe5f2", ctermfg="White"})
vim.api.nvim_set_hl(0, "SpellBad", {fg="#ff6e7a", ctermfg="Red", underline=1})
vim.api.nvim_set_hl(0, "MatchParen", {fg="#6ebeff", ctermfg="Blue", underline=1})
vim.api.nvim_set_hl(0, "Visual", {bg="#434c5e", ctermfg="Black", ctermbg="White"})
vim.api.nvim_set_hl(0, "Cursor", {fg="#21242b", bg="#6ebeff", ctermfg="Black", ctermbg="Blue"})
vim.api.nvim_set_hl(0, "TabLine", {fg="#dfe5f2", bg="#3e4452", ctermfg="White", ctermbg="Gray"})
vim.api.nvim_set_hl(0, "PmenuSel", {fg="#21242b", bg="#6ebeff", ctermfg="Black", ctermbg="Blue"})
vim.api.nvim_set_hl(0, "Search", {fg="#5c6370", bg="#ffd587", ctermfg="Black", ctermbg="Yellow"})
vim.api.nvim_set_hl(0, "StatusLine", {fg="#21242b", bg="#6ebeff", ctermfg="Black", ctermbg="Blue"})
vim.api.nvim_set_hl(0, "IncSearch", {fg="#ffd587", bg="#5c6370", ctermfg="Yellow", ctermbg="Black"})
vim.api.nvim_set_hl(0, "QuickFixLine", {fg="#21242b", bg="#ffd587", ctermfg="Black", ctermbg="Yellow"})