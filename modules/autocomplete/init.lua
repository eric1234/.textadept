-- Since we auto-activate auto complete we don't want to auto-choose on single
-- in case they are typing an entirely new term.
buffer.auto_c_choose_single = false

-- It is typical for one buffer to make use of structures in another buffer
-- so scan all open buffers for auto-complete.
textadept.editing.autocomplete_all_words = true

-- Operates like (and based on) the standard autocomplete list but instead can
-- accept multiple autocomplete functions that will be combined together.
local function multi_autocomplete(...)
  local list = {}
  local len_entered

  for _, name in ipairs({...}) do
    if not textadept.editing.autocompleters[assert_type(name, 'string', 1)] then goto continue end
    local len, cur_list = textadept.editing.autocompleters[name]()
    len_entered = len
    table.move(cur_list, 1, #cur_list, #list + 1, list)
    ::continue::
  end

  if not len_entered or not list or #list == 0 then return end
  buffer.auto_c_order = buffer.ORDER_PERFORMSORT
  buffer:auto_c_show(len_entered, table.concat(list, string.char(buffer.auto_c_separator)))
  return true
end

-- Auto-activate auto-complete when character typed
events.connect(events.CHAR_ADDED, function()
  if buffer:auto_c_active() then
    buffer:auto_c_cancel()
  end

  -- Only try to auto-complete if more than 2 characters have been typed
  local wordStart = buffer:word_start_position(buffer.current_pos, true)
  if buffer.current_pos - wordStart <= 2 then return end

  -- If in comment then do not auto-complete.
  -- Look at prev character since end of comment line not considered in comment
  buffer:colorize(1, buffer.current_pos)
  local style = buffer:name_of_style(buffer.style_at[buffer.current_pos-1])
  if( style == 'comment' ) then return end

  multi_autocomplete('word', 'snippet')
end)

-- If inserted auto-complete can activate a snippet then activate it
events.connect(events.AUTO_C_COMPLETED, function()
  textadept.snippets.insert()
end)

-- Monkey-patch word auto-completer to ignore words that are in comments
-- This is exactly the method from
-- https://github.com/orbitalquark/textadept/blob/bb14dfe31c87ebf9b1489186c7a023ef6582d952/modules/textadept/editing.lua#L674-L695
-- only the conditional for adding a match as been modified to see if the match
-- is in the "comment" style. If so it is ignored.
--
-- I concatacted the devleoper to see if there is a way we can upstream this
-- or at least remove the need for the monkey-patch by having a hook but they
-- where not interested so just maintaining my own fork.
textadept.editing.autocompleters.word = function()
  local list, matches = {}, {}
  local s = buffer:word_start_position(buffer.current_pos, true)
  if s == buffer.current_pos then return end
  local word_part = buffer:text_range(s, buffer.current_pos)
  for _, buffer in ipairs(_BUFFERS) do
    if buffer == _G.buffer or textadept.editing.autocomplete_all_words then
      buffer.search_flags = buffer.FIND_WORDSTART |
        (not buffer.auto_c_ignore_case and buffer.FIND_MATCHCASE or 0)
      buffer:target_whole_document()
      while buffer:search_in_target(word_part) ~= -1 do
        local e = buffer:word_end_position(buffer.target_end, true)
        local style = buffer:name_of_style(buffer.style_at[buffer.target_start])
        local match = buffer:text_range(buffer.target_start, e)
        if style ~= 'comment' and #match > #word_part and not matches[match] then
          list[#list + 1], matches[match] = match, true
        end
        buffer:set_target_range(e, buffer.length + 1)
      end
    end
  end
  return #word_part, list
end

