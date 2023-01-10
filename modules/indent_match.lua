function string.trim(str)
  return str:gsub('^%s+', ''):gsub('%s+$', '')
end

view.indentation_guides = view.IV_NONE

events.connect(events.UPDATE_UI, function(updated)
  -- We only care when the cursor moves
  if not (updated & buffer.UPDATE_SELECTION) then return end

  -- Hide any previous call-tip displaying matching indentation
  view.call_tip_cancel()

  local line = buffer:line_from_position(buffer.current_pos)
  local line_text = buffer.get_line(line)
  local blank = line_text == "\n"

  -- Just return for now but perhaps in the future find the first non-blank
  -- line below the current line?
  if blank then return end

  -- First line can't match up to anything so return early otherwise we get an
  -- error trying to read the previous line.
  if line == 1 then return end

  local cur_indent = buffer.line_indentation[line]
  local prev_indent = buffer.line_indentation[line-1]

  -- If the previous line is not nested return early as we are ending a
  -- indention match
  if prev_indent <= cur_indent then return end

  repeat
    line = line - 1
    prev_indent = buffer.line_indentation[line]
    line_text = buffer:get_line(line)
    blank = line_text == "\n"
  until prev_indent <= cur_indent and not blank

  line_text = line_text:trim()
  view:call_tip_show(buffer.current_pos, line_text)
end)
