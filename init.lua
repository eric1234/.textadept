textadept.log = require('log')

require('spellcheck')

require('utilities')
require('declutter')
require('autosave')
require('no_tabs')
require('contraction')
require('wide_screen')
require('quote_toggle')
require('autocomplete')
require('snippets')
require('quick_open')

-- A visual indicator on preferred max line length
view.edge_column = 80
view.edge_mode = view.EDGE_LINE

-- Remove those extra spaces that shouldn't be there
textadept.editing.strip_trailing_spaces = true

-- Surround selected text with auto pairs
textadept.editing.auto_enclose = true

-- Assume currently selected text is what we want to search for
textadept.key_replace(ui.find.focus, function()
  ui.find.focus{find_entry_text = buffer:get_sel_text()}
  buffer:set_selection(0, 0)
end)
