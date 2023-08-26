-- Copies the path of the current file relative to the project root. Makes it
-- ideal for copy/pasting into the CLI. By default assumes you just want it
-- from the root path but ctrl+alt+shift-p will give you the full path.
local function copy_path(from_root)
  local current_path = buffer.filename
  local project_root = io.get_project_root()

  if not from_root and project_root then
    current_path = current_path:sub(#project_root+2)
  end

  ui.clipboard_text = current_path
end

local function copy_full_path() copy_path(true) end

alt_command('p', copy_path)
alt_command('P', copy_full_path)

local edit_menu = textadept.menu.menubar['Edit']
edit_menu[#edit_menu + 1] = { 'Copy Path', copy_path }
edit_menu[#edit_menu + 1] = { 'Copy Full Path', copy_full_path }
