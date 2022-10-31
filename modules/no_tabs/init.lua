local function buffer_in_use(buf)
  return table.contains(_VIEWS, function(view)
    return view.buffer.filename == buf.filename
  end)
end

local function close_unused_buffers()
  -- Cleanup doesn't have to happen right away and I think there are race
  -- conditions if we do it too early after an event
  timeout(2, function()
    for _, buf in ipairs(_BUFFERS) do
      if not buffer_in_use(buf) then
        buf:close()
      end
    end
  end)
end

ui.tabs = false
events.connect(events.FILE_OPENED, close_unused_buffers)
events.connect(events.BUFFER_AFTER_SWITCH, close_unused_buffers)
