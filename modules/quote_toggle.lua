-- Toggle between the different quote types in a language. Default to toggling
-- between ' and " but there is a hook for other languages to do what makes
-- sense for that language. Hotkey is Ctrl-" for PC and Cmd-" for Mac.

local M = {}

-- Single and double quotes are pretty standard in most languages. Some
-- languages such as JavaScript has other options like backquotes
M.quote_toggles = {
  javascript = '"\'`',
}
setmetatable(M.quote_toggles, { __index = function() return '"\'' end })

-- Usually escape with a backslash but also make as a language based table for flex
M.quote_toggle_escape = {}
setmetatable(M.quote_toggle_escape, { __index = function() return '\\' end })

local function in_string(pos)
  return buffer:name_of_style(buffer.style_at[pos]) == 'string'
end

local function next_quote(lexer, current)
  local quote_toggles = M.quote_toggles[lexer]
  local idx = quote_toggles:find(current)
  idx = idx + 1
  if( idx > #quote_toggles) then idx = 1 end
  return quote_toggles:sub(idx, idx)
end

M.toggle = function()
  if not in_string(buffer.current_pos) then return end

  local pos = buffer.current_pos
  local start = pos
  local finish = pos

  while in_string(start) do
    start = buffer:position_before(start)
  end
  start = buffer:position_after(start)

  while in_string(finish) do
    finish = buffer:position_after(finish)
  end

  local str = buffer:text_range(start+1, finish-1)
  local lexer = buffer:get_lexer(true)
  local cur = buffer:text_range(start, buffer:position_after(start))
  local nxt = next_quote(lexer, cur)
  local escape = M.quote_toggle_escape[lexer]

  str = str:gsub('([^'..escape..'])'..nxt, '%1'..escape..nxt)
  str = str:gsub('^'..nxt, escape..nxt)
  str = nxt..str..nxt

  buffer:set_target_range(start, finish)
  buffer:replace_target(str)
  buffer:goto_pos(pos)
end

if OSX then
  keys['cmd+"'] = M.toggle
else
  keys['ctrl+"'] = M.toggle
end

return M
