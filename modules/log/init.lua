return function(...)
  local args = {...}
  local msg = args[#args]
  if #args == 2 then msg = os.date()..'['..args[1]..'] '..msg end

  local logger = os.spawn('tee -a '.._USERHOME..'/activity.log')
  logger:write(msg.."\n")
  logger:close()
end
