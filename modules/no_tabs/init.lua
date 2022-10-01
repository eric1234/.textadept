function contains(table, evaluator)
  for _, item in ipairs(table) do
    if evaluator(item) then return true end
  end

  return false
end

function close_unused_buffers()
  for _, buffer in ipairs(_BUFFERS) do
    local is_use = contains(_VIEWS, function(view) return view.buffer == buffer end)
    if not is_use then buffer:close() end
  end
end

ui.tabs = false
events.connect(events.FILE_OPENED, close_unused_buffers)
events.connect(events.BUFFER_AFTER_SWITCH, close_unused_buffers)
