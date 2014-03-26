---
layout: post
title: "Hitch-hiker's guide to rebasing"
date: 2014-03-24 18:33:00 +0530
comments: true
categories: 
---
Git rebase is one of those features which people tell you not to use. Understand this, it is one of the most powerful tool git has to offer. People fear it because it is one of those few tools capable of irreversibly(maybe) damaging your git history. But don't expect to be a git ninja without knowing how to do a conflict-ridden `git rebase -i`. I'll try to provide a scenario based approach to learning rebase. Here are a couple of conventions I'll follow in my git graphs.

<!-- more -->

 - `*` represent the commits which you don't want affected
 - `x` represent the commits which you want to move over or which were affected by rebasing

But first...

What is rebasing
----------------------

Every git commit except the first one has at least one parent. Its base, if you will. i.e. each commit is based off another commit. When I say 'based off', I mean it borrows all the files from its parent except the ones that have been changed and creates objects representing new changes on top of that.

Rebasing, in simplest terms means changing the parent of a commit. That's the full definition of rebasing, although git allows you some utilities to make some other changes too.

Visually, rebasing means you can move actual commits between branches. Cherry-picking means rebasing just a single commit. Nothing fancy there. Rebasing is generally associated with moving over more than one commit.

Now back to business. Here are some use cases of rebasing.

Rebasing a branch over another
------------------------------------------

  We have something like:

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

Interactive rebasing
------------------------

This will take time and is a little dodgy to get right in the first try. I recommend a test repo for this one.

To do an interactive rebase, you just add a `-i` option to any rebase command we discussed. This will open up a text editor with some commits listed along with their hashes. These are the commits which will be affected by rebasing. The general format of a line is:

```bash
<action> <hash> <commit_message>
```

You'll notice that `pick` is applied by default to all the commits. This means that if you save and exit the file now, the rebase will be no different than what you have done without the -i flag. But we didn't go interactive for nothing. We get a wealth of actions which can help re-write git history anyway we see fit. Here's what they are supposed to do.

- p/pick: The commit will be rebased without any modifications. This is what you do if you don't do an interactive rebase.
- r/reword: When the rebase operation will get to this commit, it will pause and prompt you for a new commit message.
- e/edit: The rebase operation will pause before rebasing this commit. You can change files, amend them in this commit and do a `git rebase --continue` to resume rebasing.
- s/squash: Git will pause rebasing before this commit and prompt you for a new commit message. Then it will merge (amend) this commit into the previous one.
- f/fixup: This is just like "squash", but discards this commit's log message. Git doesn't pause for this one. The commit is automatically merged into its parent.

Know that if a commit is rebased, it will in reality create an entirely new commit. This means that you should not rebase commits which you have already pushed somewhere. If you do, it is still possible to synchronize your new history but other co-workers (if any) might not appreciate the extra work.

Don't fret the conflicts!
-----------------------------

Always expect conflicts. It will save you from a nasty shock when you just want to do a rebase quickly and leave for weekend. However, if you know what you are doing, the conflicts are handled pretty systematically. If you even run into a conflict during rebase, git will tell you about the naughty files. Open them, correct them and save them. Then do a `git add <conflicting_files>`. Make sure you don't commit your changes. Then simply continue rebasing with `git rebase --continue`.

Even if go cold-feet and want to opt out from rebasing, you can do a `git rebase --abort` and git will give you back your history just as it was before you started.

Recovering lost commits
--------------------------

I already told you the rebase commits are actually entirely different commits and git will stop showing you your old ones. So you actually completed a rebase and now want to recover your previous commits. You are conflicted! But git is lenient. It will not actually delete those old commits until next cleaning cycle (once every few weeks maybe). You can search for your lost commits by running reflog.

```bash
$ git reflog

2356552 HEAD@{0}: commit: New post: Git rebase (incomplete)
2056160 HEAD@{1}: commit (amend): New post: Lazy definitions in javascript
1a2c1b5 HEAD@{2}: commit (amend): New post: Lazy definitions in javascript
5b6f6c6 HEAD@{3}: commit: New post: Lazy definitions in javascript
...
```

The above is a reflog of this blog I pulled up just as I am writing this. Luckily, you can see how rebasing or amending a commit will give you a new one. You can also see the hash of old commit (5b6f6c6) here. Note the SHA-hash, check it out, make a branch on it. You won't lose it again.

There is almost always a way of recovering your stuff in git. That is if you don't have a habit of running `git gc` after every operation.

I hope I helped at least one of you with rebasing. I'll be delighted to add more scenarios to this post if you can suggest them.

Thanks for reading.
