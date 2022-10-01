-- I use the quick open mostly to navigate to other files
dofile('./no_tabs.lua')

-- Don't auto-pair ' in certain situations
dofile('./contraction.lua')

-- Simplified layout control
dofile('./column_layout.lua')

-- Because I can't spell worth shit
require('spellcheck')

-- Keyboard shortcuts > Menu and less clutter
events.connect(events.INITIALIZED, function()
  textadept.menu.menubar = nil
end)

-- Code folding is not useful to me and too busy visually to leave enabled
lexer.folding = false
view.margin_width_n[3] = 0

-- A visual indicator on preferred max line length
view.edge_column = 80
view.edge_mode = view.EDGE_LINE

-- Remove those extra spaces that shouldn't be there
textadept.editing.strip_trailing_spaces = true

-- My projects tend to be a lot of little files
io.quick_open_max = 10000

-- Surround selected text with auto pairs
textadept.editing.auto_enclose = true

-- Ctrl-Cmd-Shift-P is too many damn keys
keys['ctrl+o'] = io.quick_open

-- Ctrl-Esc involves moving the hand too much. Prefer the PC way
if OSX then keys['cmd+\n'] = keys['ctrl+esc'] end

-- Temp directory should not be included in default search
table.insert(lfs.default_filter, '!/tmp$')

-- Make it easy to replace a function with my version while keeping the same
-- keycodes regardless of platform
local function key_replace(old_func, new_func)
  for keycode, func in pairs(keys) do
    if func == old_func then keys[keycode] = new_func end
  end
end

-- Assume currently selected text is what we want to search for
key_replace(ui.find.focus, function()
  ui.find.focus{find_entry_text = buffer:get_sel_text()}
  buffer:set_selection(0, 0)
end)

-- Auto-save all unsaved buffers switching focus
events.connect(events.UNFOCUS, io.save_all_files)
events.connect(events.BUFFER_BEFORE_SWITCH, io.save_all_files)
events.connect(events.VIEW_BEFORE_SWITCH, io.save_all_files)
