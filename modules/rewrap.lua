M = {}

-- Putting some generic functions in the global space as we might eventually
-- use them in other modules and therefore move them to the global utilities.
-- Basically any methods that would be part of the stdlib for a full featured
-- language.

-- Assumes an array-like table. Returns a new array mapping value via callback
function table.map(list, callback)
  local ret = {}
  for _, item in ipairs(list) do
    table.insert(ret, callback(item))
  end
  return ret
end

-- Assuming an array-like table. Removes all items that evaluate to false.
function table.compact(list)
  local ret = {}
  for _, item in ipairs(list) do
    if item then
      table.insert(ret, item)
    end
  end
  return ret
end

-- Extends string to allow splitting via the given pattern
function string.split(content, pattern)
  local list = {}
  for item in content:gmatch(pattern) do
    table.insert(list, item)
  end
  return list
end

-- Extends string to allow splitting by lines. Multiple line breaks are collapsed
-- and can operate on the different line break types (\r, \n, and \r\n).
function string.split_lines(content)
  return content:split("[^\r\n]+")
end

-- Extends string to split by spacing between words.
function string.split_words(content)
  return content:split("[^ ]+")
end

-- Extends string to get a character at a specific location
function string.char_at(str, idx)
  return str:sub(idx, idx)
end

-- Now the stuff truly local to this module

local function modifying_selection(callback)
  -- We rewrap entire lines
  buffer.selection_mode = buffer.SEL_LINES

  local original = buffer:get_sel_text()
  local modified = callback(original)

  -- Conditionally replace to avoid marking the buffer as dirty
  if( original ~= modified ) then buffer:replace_sel(modified) end

  -- Revert back to original selection mode
  buffer:cancel()
end

local function strip_prefix(items, prefix)
  return table.map(items, function(item)
    local stripped = item:gsub('^'..prefix, '')
    return stripped
  end)
end

local function prepend_prefix(items, prefix)
  return table.map(items, function(item)
    return prefix..item
  end)
end

local function extract_prefix(lines)
  local idx = 1
  local prefix = ''
  local mismatch = false

  repeat
    local cur = lines[1]:char_at(idx)

    for _, line in ipairs(lines) do
      if line:char_at(idx) ~= cur then
        mismatch = true
        goto continue
      end
    end

    idx = idx + 1
    prefix = prefix..cur

    ::continue::
  until mismatch

  return strip_prefix(lines, prefix), prefix
end

local function add_word(content, word)
  if #content == 0 then
    return word
  else
    return content..' '..word
  end
end

local function tap(val, callback)
  callback(val)
  return val
end

local function rewrap(width, lines)
  local line = ''
  local words = table.concat(lines, ' '):split_words()
  local rewrapped = table.compact(table.map(words, function(word)
    local test = add_word(line, word)

    if #test > width then
      return tap(line, function() line = word end)
    else
      line = test
      return nil
    end
  end))
  table.insert(rewrapped, line)
  return rewrapped
end

function M.rewrap()
  modifying_selection(function(to_rewrap)
    local orig_lines, prefix = extract_prefix(to_rewrap:split_lines())
    local width = view.edge_column - #prefix
    return table.concat(prepend_prefix(rewrap(width, orig_lines), prefix), "\n")
  end)
end

keys['ctrl+Q'] = M.rewrap

return M
