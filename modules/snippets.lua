-- Put Ruby ones in event callback so I can clear out ones defined by stock module
events.connect(events.LEXER_LOADED, function(name)
  if name ~= 'ruby' then return end

  -- Most of the stock ones I don't use so make my own Ruby list
  snippets.ruby = {}
  local snip = snippets.ruby

  -- Stock ones I restored
  snip['if'] = 'if %1(condition)\n\t%0\nend'
  snip.case = 'case %1(object)\nwhen %2(condition)\n\t%0\nend'
  snip.cla = 'class %1(ClassName)\n\t%0\nend'
  snip.def = 'def %1(method_name)\n\t%0\nend'
  snip['do'] = 'do\n\t%0\nend'

  -- Custom snippets
  snip.exp = 'expect( %1(subject) ).to %0'
  snip.expb = 'expect { %1 }.to %0'
  snip.let = 'let(%1) { %0 }'
  snip.letb = 'let %1 do\n\t%0\nend'
end)

local snip = snippets.javascript
snip.exp = 'expect( %1 ).to%0'
snip.log = 'console.log(%1)%0'
