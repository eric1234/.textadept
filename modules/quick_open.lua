-- My projects tend to be a lot of little files
io.quick_open_max = 10000

-- Temp or storage directory should not be included in default search
table.insert(lfs.default_filter, '!/tmp$')
table.insert(lfs.default_filter, '!/storage$')

-- Quick open will by default open a file descending from the project root of
-- the current buffer. I think it will be more useful to filter for the project
-- root of all open buffers. Most of the time all buffers will share the same
-- root. But if not then it allows the current file to be replaced with a file
-- from another project root you are currently working on.
local function quick_open_all()
  local paths = {}

  for _, buf in ipairs(_BUFFERS) do
    local root = io.get_project_root(buf.filename)
    if not table.contains(paths, root) then
      table.insert(paths, root)
    end
  end

  io.quick_open(paths)
end

-- Ctrl-Cmd/Alt-Shift-P is too many damn keys for so common an operation. Since
-- we already have the up arrow for moving up I won't ever use Ctrl-P (in Mac
-- cmd-P). Therefore stealing that keyboard shortcut. This also makes it the
-- same shortcut as Atom's fuzzy finder which is similar functionality.
if OSX then
  keys['cmd+p'] = quick_open_all
else
  keys['ctrl+p'] = quick_open_all
end
