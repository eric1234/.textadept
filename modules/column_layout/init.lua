local M = {}

-- Verify current layout is compatible with hwo this module assumes the splits.
local function validate_layout(st)
  if st.vertical == nil then
    return true
  elseif st.vertical == true then
    return validate_layout(st[1]) and validate_layout(st[2])
  else
    return false
  end
end

local function get_views(st)
  if st.vertical == nil then
    return st
  else
    return st[1], get_views(st[2])
  end
end

local function add_views(last_view, num_to_add, per)
  for i=1, num_to_add do
    _, last_view = last_view:split(true)
    last_view.size = per
  end
end

local function remove_views(views, num_to_remove, per)
  for i=0, #views-1 do
    local cur = views[#views - i]

    if num_to_remove > 0 then
      if cur ~= view then
        cur:unsplit()
        num_to_remove = num_to_remove - 1
      end
    else
      cur.size = per
    end
  end
end

local function assert_layout()
  local st = ui.get_split_table()
  assert(validate_layout(st), 'Current layout incompatible')

  return get_views(st)
end

function M.set_column_count(count)
  local views = { assert_layout() }
  local per = math.floor(ui.size[1] / count)

  if #views == count then
    return
  elseif #views < count then
    add_views(views[#views], count - #views, per)

    for _, view in ipairs(views) do
      view.size = per
    end
  else
    remove_views(views, #views - count, per)
  end

  ui.update()
end

for i=1, 9 do
  keys['ctrl+alt+'..i] = function()
    M.set_column_count(i)
  end
end

function M.switch_to_column(idx)
  local views = { assert_layout() }

  ui.goto_view(_VIEWS[views[idx]])
end

for i=1, 9 do
  keys['ctrl+'..i] = function()
    M.switch_to_column(i)
  end
end

return M
