return function(...)
  local args = {...}
  local msg = args[#args]
  if #args == 2 then msg = '['..args[1]..'] '..msg end
  msg = os.date()..' '..msg

  local logger = os.spawn('tee -a '.._USERHOME..'/activity.log')
  logger:write(msg.."\n")
  logger:close()
end
