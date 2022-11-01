-- Returns a function that ensures only once instance of it is active at
-- a time. If another thread calls the same function it will be ignored.
-- Also adds a slight delay to processing the function so the if another
-- process will be using the unused buffer very shortly they can grab it before
-- the cleanup.
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

-- Store what views are using what buffers. Then run the callback. Then ensure
-- those associations from before as still valid. This is needed because
-- sometimes closing a buffer seems to cause an unrelated view change to an
-- unrelated buffer
local function ensure_buffer_assignment(callback)
  local usage = {}
  for _, view in ipairs(_VIEWS) do
    usage[view] = view.buffer
  end

  callback()

  for view, buffer in pairs(usage) do
    view:goto_buffer(buffer)
  end
end

local function buffer_in_use(buf)
  return table.contains(_VIEWS, function(view)
    return view.buffer.filename == buf.filename
  end)
end

local close_unused_buffers = debounce(function()
  ensure_buffer_assignment(function()
    for _, buf in ipairs(_BUFFERS) do
      if not buffer_in_use(buf) then buf:close() end
    end
  end)
end)

ui.tabs = false
events.connect(events.FILE_OPENED, close_unused_buffers)
events.connect(events.BUFFER_AFTER_SWITCH, close_unused_buffers)
