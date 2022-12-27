-- Since Mac won't print to the console we want to allow debugging via the
-- normal print where the output instead goes to a file
if OSX then
  function print(...)
    local args = {...}
    local file = io.open(_USERHOME..'/debug.log', 'a+')
    for _, item in ipairs(args) do
      file:write(item, "\t")
    end
    file:write("\n")
    file:close()
  end
end
