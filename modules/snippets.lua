local snip = snippets.ruby

-- Stock Ruby ones from old module
snip['if'] = 'if ${1:condition}\n\t$0\nend'
snip.case = 'case ${1:object}\nwhen ${2:condition}\n\t$0\nend'
snip.cla = 'class ${1:ClassName}\n\t$0\nend'
snip.def = 'def ${1:method_name}\n\t$0\nend'
snip['do'] = 'do\n\t$0\nend'

-- Custom Ruby snippets
snip.exp = 'expect( ${1:subject} ).to $0'
snip.expb = 'expect { $1 }.to $0'
snip.let = 'let($1) { $0 }'
snip.letb = 'let $1 do\n\t$0\nend'
snip.Given = "Given '$1' do\n\t$0\nend"
snip.When = "When '$1' do\n\t$0\nend"
snip.Then = "Then '$1' do\n\t$0\nend"

-- JavaScript
snip = snippets.javascript
snip.exp = 'expect( $1 ).to$0'
snip.log = 'console.log($1)$0'
