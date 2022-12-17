-- My projects tend to be a lot of little files
io.quick_open_max = 10000

-- Temp directory should not be included in default search
table.insert(lfs.default_filter, '!/tmp$')

-- Ctrl-Cmd/Alt-Shift-P is too many damn keys for so common an operation. Since
-- we already have the up arrow for moving up I won't ever use Ctrl-P (in Mac
-- cmd-P). Therefore stealing that keyboard shortcut. This also makes it the
-- same shortcut as Atom's fuzzy finder which is similiar functionality.
if OSX then
  keys['cmd+p'] = io.quick_open
else
  keys['ctrl+p'] = io.quick_open
end
