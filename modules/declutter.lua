-- Prefer keyboard shortcuts or a command palette over navigating a menu and
-- the menu just adds clutter so disable it.
events.connect(events.INITIALIZED, function()
  -- Don't disable on OSX because of a bug
  -- https://github.com/orbitalquark/textadept/issues/444
  if not OSX then textadept.menu.menubar = nil end
end)

-- Code folding is not useful to me and too busy visually to leave enabled
lexer.folding = false
view.margin_width_n[3] = 0
