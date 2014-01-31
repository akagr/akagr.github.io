---
layout: post
title: "Rudimentary Sessions for Vim"
date: 2013-12-20 10:26:52 +0530
comments: true
categories: [vim]
---
I have been taking a lot of vim with coffee lately. I really like the raw power of this editor. Up till now I have found replacement commands, mappings and plugins for most of my daily used features. Still, vim does not see projects and there is no automatic sessions support built-in.

The plugins on offer are excellent in their own right but they did not cut it for me. Plus, I really want to get into hacking editor part and it was a nice excuse to try out some of the vimscript I learnt.

<!--more-->

I started off a fork of casastorta's plugin of same name and got some autoloading in to avoid performance impact. I have also made the 'save session on exit default'. The plugin once installed will try to save a session automatically in the current directory when you exit vim. Aaaannnnd, **spoiler alert**, it will also load the session when you fire up vim from same directory next time. It should fit right in if you plan to open vim from root of you projects.

Enough talk, lets see some code:

```vim
function! sessions#create()
   let path = getcwd()
   if !filewritable('./.session.vim')
      if tolower(input("No session file in " . path . ". Create one? [Y]es/[N]o ")) =~ "y"
         mksession! ./.session.vim
      endif
   else
      if tolower(input("Session file " . path . "/.seesion.vim already exists. Overwrite? [Y]es/[N]o? ")) =~ "y"
         let s:sessionautoloaded = 1
         call sessions#save()
      endif
   endif
endfunction

function! sessions#save()
   if s:sessionautoloaded == 1
      mksession! ./.session.vim
      echom "Session saved."
      "source ./.session.vim
   else
      echom "No session to save. Please create session with ':mksession .session.vim' first! "
      if tolower(input("Autocreate session for you? [Y]es/[N]o ")) =~ "y"
         call sessions#create()
      endif
   endif
endfunction

function! sessions#load()
   " Rudimentary session management
   if version >= 700
      set sessionoptions=blank,buffers,sesdir,tabpages,winpos,folds,options,unix,slash
   endif

   if !exists("s:sessionautoloaded")
      let s:sessionautoloaded = 0
   endif

   if filereadable('./.session.vim')
      if s:sessionautoloaded == 0
         source ./.session.vim
         let s:sessionautoloaded = 1
         echom "Session loaded."
      endif
   endif
endfunction
```
If you have any interest in scripting vim, above is a fairly easy noob code. The snippet from my base plugin is as follows:
```vim
if exists('b:loaded_rudimentary_sessions_ftplugin')
   finish
endif
let b:loaded_rudimentary_sessions_ftplugin = 1

" Session is saved with <leader>ss (<leader> is \ by default)
nmap <silent> <leader>ss :call sessions#save()<CR>
nmap <silent> <leader>sc :call sessions#create()<CR>
nmap <silent> <leader>sl :call sessions#load()<CR>

augroup RudimentarySession
	autocmd VimEnter * call sessions#load()
  autocmd VimLeave * call sessions#save()
augroup END
```
Before you think of installing this plugin, you might want to know a few issues that I noticed. First, if a session file exists in the directory, vim will always load it. Always. Even if you specify a file explicitly while opening vim. The file will be opened, sure, but in a hidden buffer. You will have to navigate to that file on your own.

Second, it might get a little confusing when every directory can potentially house a vim session file. It will get unpredictable what you will see on entering vim from a particular directory. It will be good to have some sort of organization to these session files.

If you want to give it a go, use your favorite vim bundle manager to install it from [my git repo here](https://github.com/akagr/vim-rudimentary-sessions).

If you have any suggestions or issues, take it to the github issue tracker. It ain't there for nothing.
