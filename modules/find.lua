-- Make it easy to replace a function with my version while keeping the same
-- keycodes regardless of platform
function textadept.key_replace(old_func, new_func)
  for keycode, func in pairs(keys) do
    if func == old_func then keys[keycode] = new_func end
  end
end

-- Assume currently selected text is what we want to search for
textadept.key_replace(ui.find.focus, function()
  ui.find.focus{find_entry_text = buffer:get_sel_text()}
  buffer:set_selection(0, 0)
end)
