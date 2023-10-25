local M = {}

function M.file_rename()
  local old_path = buffer.filename
  local new_path = ui.dialogs.input{ title = 'Enter New Filename', text = old_path }
  if not new_path then return end

  buffer:close(true)
  os.rename(old_path, new_path)
  io.open_file(new_path)
end

function M.file_remove()
  local path = buffer.filename
  buffer:close(true)
  buffer:new()
  os.remove(path)
end

command('R', M.file_rename)
alt_command('D', M.file_remove)

local buffer_menu = textadept.menu.menubar['Buffer']
buffer_menu[#buffer_menu + 1] = { 'Delete File', M.file_remove }

return M
