-- Make it easy to replace a function with my version while keeping the same
-- keycodes regardless of platform
function textadept.key_replace(old_func, new_func)
  for keycode, func in pairs(keys) do
    if func == old_func then keys[keycode] = new_func end
  end
end

textadept.key_replace(ui.find.focus, function()
  ui.find.focus()

  local cur = buffer:get_sel_text()

  -- User selected text. Assume that is what we search for
  if cur ~= '' then
    ui.find.find_entry_text = cur
    ui.find.replace_entry_text = ''
    buffer:set_selection(0, 0)
  end
end)
