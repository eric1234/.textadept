local M = {}

local function add_views(num_to_add)
  for _=1, num_to_add do
    _VIEWS[#_VIEWS]:split(true)
  end
end

local function remove_view(position)
  for i=position, #_VIEWS-1 do
    _VIEWS[i]:goto_buffer(_VIEWS[i+1].buffer)
  end
  _VIEWS[#_VIEWS-1]:unsplit()
end

local function even_size()
  local per = math.floor(ui.size[1] / #_VIEWS)

  for _, view in ipairs(_VIEWS) do
    view.size = per
  end
end

-- I make all views even anytime I change the column count but also poll the
-- window width so if the user resizing the windows the columns stay event
local window_width = ui.size[1]
timeout(0.25, function()
  if( window_width == ui.size[1] ) then return true end

  window_width = ui.size[1]
  even_size()

  return true
end)

function M.toggle_column(position)
  local initial_view_count = #_VIEWS

  if initial_view_count == 1 and position == 1 then
    -- Only a single view and the user told us to close it. Ignore the user
    return
  elseif initial_view_count < position then
    add_views(position - initial_view_count)
    M.switch_to_column(initial_view_count + 1)
  else
    remove_view(position)
  end

  even_size()
end

for i=1, 9 do
  keys['ctrl+alt+'..i] = function()
    M.toggle_column(i)
  end
  keys['ctrl+cmd+'..i] = keys['ctrl+alt+'..i] -- for Mac
end

function M.swap_with(position)
  a = _VIEWS[position].buffer
  b = view.buffer

  _VIEWS[position]:goto_buffer(b)
  view:goto_buffer(a)
  M.switch_to_column(position)
end

for i, k in ipairs({'!', '@', '#', '$', '%', '^', '&', '*', '('}) do
  keys['ctrl+'..k] = function()
    M.swap_with(i)
  end
end

function M.switch_to_column(idx)
  -- Just return early if they indicate move to a column we don't have
  if( idx > #_VIEWS ) then return end

  ui.goto_view(_VIEWS[idx])
end

for i=1, 9 do
  keys['ctrl+'..i] = function()
    M.switch_to_column(i)
  end
end

return M
