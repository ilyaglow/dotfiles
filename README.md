[![Build Status](https://travis-ci.org/ilyaglow/dotfiles.svg?branch=master)](https://travis-ci.org/ilyaglow/dotfiles)

About
-----

Dot files repo. Everything you need to check my setup out is a rake.

# Vim cheat sheet

I list shortcuts here that I tend to forget and keep googling everytime

## Plain vim

Open selected split in a new tab
```
<CTRL-w>T
```

Insert same word multiple times in insert mode
```
<CTRL-o>1000i<word>Esc
```

Insert list of numbers
```
:put =range(1,10)
```

Insert list of IP-addresses
```
:for i in range(1,10) | put ='192.168.0.'.i | endfor
```


## Plugins cheat sheet

### surround

"A sentence" -> 'A sentence' (cursor is inside the quotes)
```
cs"'
```

Things -> "Things" (inside word)
```
ysiw"
```

### unimpaired

Do urlencode/urldecode selected text
```
[u
]u
```

Add new line before/after cursor
```
[<Space>
]<Space>
```

### commentary

Toggle comment on line
```
gcc
```

Toggle comments on visual selected lines
```
gc
```

### gitgutter

Jump to next/previous change
```
[c
]c
```

Stage/unstage hunk
```
,hs
,hu
```

Preview hunk
```
,hp
```
