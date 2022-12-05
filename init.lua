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
require('rewrap')
require('find')

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


