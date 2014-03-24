---
layout: post
title: "Hitch-hiker's guide to rebasing"
date: 2014-03-24 18:33:00 +0530
comments: true
published: false
categories: 
---
Git rebase is one of those features which people tell you not to use. Understand this, it is one of the most powerful tool git has to offer. People fear it because it is one of those few tools capable of irreversibly(maybe) damaging your git history. But don't expect to be a git ninja without knowing how to do a conflict-ridden `git rebase -i`. I'll try to provide a scenario based approach to learning rebase. Here are a couple of conventions I'll follow in my git graphs.

 - `*` represent the commits which you don't want affected
 - `x` represent the commits which you want to move over or which were affected by rebasing

So here goes.

Rebasing a branch over another
------------------------------------------

  We have somthing like:

```bash
    --*--*--*--*--* (master)
       \
        x--x--x--x--x (dev)
```

To rebase dev over master, we can run:

```bash
$ git co dev
$ git rebase master

    --*--*--*--*--* (master)
                   \
                    x--x--x--x--x(dev)
```

Rebasing only some commits from tip of a branch to another
----------------------------------------------------------------
  
  We don't want to rebase full branch. Just some commits from its tip. For this we will need to create a temporary branch to save the new tip too. 

```bash
    --*--*--*--*--* (master)
       \
        *--*--*--x--x (dev)
```

We will create a new branch on the new tip first.

```bash
$ git co -b temp <commit_id>

  --*--*--*--*--* (master)
       \
        *--*--* (temp)
               \
                x--x (dev)

```

Now we can easily rebase the commits over as

```bash
$ git rebase --onto master temp dev
  
  --*--*--*--*--* (master)
        \        \
         \        x--x (dev)
          \
           *--*--* (temp)
                    
```
