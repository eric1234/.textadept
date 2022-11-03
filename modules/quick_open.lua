-- My projects tend to be a lot of little files
io.quick_open_max = 10000

-- Temp directory should not be included in default search
table.insert(lfs.default_filter, '!/tmp$')

-- Ctrl-Cmd-Shift-P is too many damn keys
keys['ctrl+o'] = io.quick_open
