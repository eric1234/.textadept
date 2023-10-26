-- For debugging and utility
require('mac_print')
require('utilities')

-- Modules provided by TextAdept
require('spellcheck')
require('format')

-- My personal modules
require('declutter')
require('autosave')
require('no_tabs')
require('contraction')
require('wide_screen')
require('quote_toggle')
require('autocomplete')
require('snippets')
require('quick_open')
require('find')
require('copy_path')
require('indent_match')
require('file_management')

buffer.use_tabs = false
buffer.tab_width = 2

-- I don't often need the same files I was working on last so would rather just
-- start with a clean slate
textadept.session.save_on_quit = false

-- A visual indicator on preferred max line length
view.edge_column = 80
view.edge_mode = view.EDGE_LINE

-- Remove those extra spaces that shouldn't be there
textadept.editing.strip_trailing_spaces = true

-- Surround selected text with auto pairs
textadept.editing.auto_enclose = true

-- I use a shell to run things so re-use binding for opening recent files
command('r', io.open_recent_file)

-- Don't prompt when file changes on disk. Unconditionally reload
events.connect(events.FILE_CHANGED, function()
  buffer:reload()
  return false
end, 1)
