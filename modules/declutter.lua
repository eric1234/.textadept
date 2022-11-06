-- Prefer keyboard shortcuts or a command palette over navigating a menu and
-- the menu just adds clutter so disable it.
events.connect(events.INITIALIZED, function()
  textadept.menu.menubar = nil
end)

-- Code folding is not useful to me and too busy visually to leave enabled
lexer.folding = false
view.margin_width_n[3] = 0
