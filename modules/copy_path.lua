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

if OSX then
  keys['ctrl+cmd+p'] = copy_path
  keys['ctrl+cmd+P'] = function() copy_path(true) end
else
  keys['ctrl+alt+p'] = copy_path
  keys['ctrl+alt+P'] = function() copy_path(true) end
end
