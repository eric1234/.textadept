-- "find" value in table using callback
function table.contains(table, evaluator)
  for _, item in ipairs(table) do
    if evaluator(item) then return true end
  end

  return false
end

-- Make it easy to replace a function with my version while keeping the same
-- keycodes regardless of platform
function textadept.key_replace(old_func, new_func)
  for keycode, func in pairs(keys) do
    if func == old_func then keys[keycode] = new_func end
  end
end
