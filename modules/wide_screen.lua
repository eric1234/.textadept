-- Layout manager to assist with developing on wide-screen displays. Makes the
-- assumption that we typically only want vertical splits in our views and that
-- we will have a lot of them. By restricting ourselves to these assumptions
-- we can let those assumptions simplify using many views. This module sets
-- up the following:
--
-- * Ctrl-1..Ctrl-9 jumps to that specific column.
-- * Ctrl-Atl-1..Ctrl-Alt-9 toggles the display of that specific column.
-- * Ctrl-Shift-1..Ctrl-Shift-9 swaps the current view with that specific column
--
-- As it manipulates these views it keeps them even width and as the window
-- size changes it keeps them even width.

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

  -- In case view being removed is focused then unfocus to prevent crash
  -- https://github.com/orbitalquark/textadept/issues/452
  if view == _VIEWS[#_VIEWS] then
    ui.goto_view(_VIEWS[#_VIEWS-1])
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

local column_menu = { title = 'Toggle Column' }
for i=1, 9 do
  local func = function()
    M.toggle_column(i)
  end

  column_menu[#column_menu + 1] = { i, func }

  alt_command(i, func)
end
local view_menu = textadept.menu.menubar['View']
view_menu[#view_menu + 1] = column_menu

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
