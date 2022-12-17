-- General methods that are useful across many scripts. Try to keep these to
-- a minimum so the modules are largely independent but we also don't want
-- duplicate code so if two modules need the same thing put that thing here.

-- "find" value in table using callback. Can also just pass an explicit value
-- and it will search for that value.
function table.contains(table, evaluator)
  if( type(evaluator) ~= 'function' ) then
    local item = evaluator
    evaluator = function(i) return i == item end
  end

  for _, item in ipairs(table) do
    if evaluator(item) then return true end
  end

  return false
end
