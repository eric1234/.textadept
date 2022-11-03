-- Keyboard shortcuts > Menu and less clutter
events.connect(events.INITIALIZED, function()
  textadept.menu.menubar = nil
end)

-- Code folding is not useful to me and too busy visually to leave enabled
lexer.folding = false
view.margin_width_n[3] = 0
