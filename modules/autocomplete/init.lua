-- Since we auto-activate auto complete we don't want to auto-choose on single
-- in case they are typing an entirely new term.
buffer.auto_c_choose_single = false

-- It is typical for one buffer to make use of structures in another buffer
-- so scan all open buffers for auto-complete.
textadept.editing.autocomplete_all_words = true

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

  textadept.editing.autocomplete('word')
end)
