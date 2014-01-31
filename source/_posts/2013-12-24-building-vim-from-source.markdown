---
layout: post
title: "Building Vim from source"
date: 2013-12-24 16:26:54 +0530
comments: true
categories: vim
---
Continuing my journey to vim enlightment, I decided to build it from source since the one I installed from apt had begun panting on large files. I won't lie, compiling from source gives me that bad-ass father of god kinda feeling; so that's two for 2. Anyways let's get started. The steps given here will install console vim with perl, python, ruby and tcl enabled. I did it on my Ubuntu precise but it should work for all things nix.

`build-dep` and `vim-gnome` are listed as dependencies for console vim. Better install those first. Also for things like ruby, python etc, you will have to install those too if you want to include their support.

I cloned the git repo of vim source from github
```bash
git clone https://github.com/b4winckler/Vim
```

Next, I needed to see what all options vim had to offer during install. You can get those with `./configure --help`. Take your time exploring this. Here's how I set what options appealed to me.
```bash
./configure \
enable-perlinterp \
enable-pythoninterp \
enable-python3interp \
enable-tclinterp \
enable-rubyinterp \
enable-multibyte \
enable-fontset \
enable-gui=no \
with-features=huge \
with-compiledby="Akash Agrawal"
```

This command creates some files in `src/auto` directory specifying install configuration. If you need to change or revise some options, or if you forgot to replace my name with yours, just delete the files in `src/auto` and configure again.
```bash
make
sudo make installed
```

Nothing special really. Just configure, make and install.
To check the fruits of your toil, use `vim --version` and it will show you all things it installed as well as your name sitting there looking rad.

I nailed it in my first try and wrinting this post from my newly installed copy. Let me know if the thing doesn't work for you.
