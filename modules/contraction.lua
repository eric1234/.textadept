-- In code I like to auto-pair ' but in text documents (plain text, markdown,
-- etc) it is usually not desired. Also in comments it is usually not desired.
-- This module allows ' to not auto-pair in those undesirable situtations while
-- still auto-pairing elsewhere.

-- Default to only doing this in comments but always do it in certian file formats
local always = false
events.connect(events.LEXER_LOADED, function(name)
  always_formats = { 'markdown', 'text' }
  always = table.contains(always_formats, name)
end)

local auto_pairs
events.connect(events.KEYPRESS, function(code)
  -- Return early if not a '
  if code ~= string.byte("'") then return end

  if not always then
    -- Look at prev character since end of comment line not considered in comment
    local style = buffer:name_of_style(buffer.style_at[buffer.current_pos-1])

    -- Return early if not a comment
    if( style ~= 'comment' ) then return end
  end

  -- Disable auto_pairs storing config in closure for later restore
  auto_pairs, textadept.editing.auto_pairs = textadept.editing.auto_pairs, nil
end)

events.connect(events.CHAR_ADDED, function()
  -- Auto-pairs config not stored so must not have been disabled. Return early
  if not auto_pairs then return end

  -- Auto-pairs was disabled for a char, restore config
  textadept.editing.auto_pairs = auto_pairs

  -- Reset closure variable to avoid restore attempt until another disable happens
  auto_pairs = nil
end)
