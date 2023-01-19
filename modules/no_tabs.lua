-- I don't find tabs useful so disable them. But just because they are hidden
-- doesn't stop old buffers from staying loaded which I just find clutters
-- my workflow. This module disables the tabs but also auto-closes any buffers
-- not in use automatically to tidy things up.


-- Workaround for this bug:
-- https://github.com/orbitalquark/textadept/discussions/264#discussioncomment-4102032
--
-- Since we are closing all non-visible buffers anyway the value of going to the
-- previous buffer doesn't really have meaning anyway so just nilling out
-- this private variable to disable the problematic functionality.
events.connect(events.BUFFER_BEFORE_SWITCH, function() view._prev_buffer = nil end)

--- Returns a function that ensures only once instance of it is active at
--- a time. If another thread calls the same function it will be ignored.
--- Also adds a slight delay to let the processing settle before doing cleanup
local function debounce(func)
  local processing = false

  return function()
    if processing then return else processing = true end
    timeout(0.1, function()
      func()
      processing = false
    end)
  end
end

local function buffer_in_use(buf)
  return table.contains(_VIEWS, function(view)
    return view.buffer.filename == buf.filename
  end)
end

local close_unused_buffers = debounce(function()
  for _, buf in ipairs(_BUFFERS) do
    if not buffer_in_use(buf) then buf:close() end
  end
end)

ui.tabs = false
events.connect(events.FILE_OPENED, close_unused_buffers)
events.connect(events.BUFFER_AFTER_SWITCH, close_unused_buffers)
events.connect(events.VIEW_AFTER_SWITCH, close_unused_buffers)
