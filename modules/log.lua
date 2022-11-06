return function(...)
  local args = {...}

  -- Last arg is what we print always
  local msg = args[#args]

  -- If there are two arguments then that is the module identifier. Output in
  -- brackets to make it easier to filter.
  if #args == 2 then msg = '['..args[1]..'] '..msg end

  -- Include date before everything so we can better tell relevant message
  msg = os.date()..' '..msg

  -- Actually open log file and write to it
  io.open(_USERHOME..'/activity.log', 'a+'):write(msg, '\n'):close()
end
