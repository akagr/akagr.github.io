---
layout: post
title: "Riak: Installation on Ubuntu 12.04"
date: 2013-12-11 17:47:38 +0530
comments: true
categories: [db, riak]
---
Riak is a relatively new kid on the block of NoSQL territory. It is based on principles of high availability, fault-tolerance, automatic replication and load balancing. Sounds like a deal for your next project... right? I got interested in one of my co-worker's project which is based on riak and decided to take it for a spin. Here is my first account with riak where I installed it on my Ubuntu 12.04 precise.

<!--more-->

First I needed to get all the prerequisites right. This involves some packages and erlang. Now I already got error with erlang OTP R14 so I decided to go with the latest R16 (B02 to be exact).

``` bash
sudo apt-get install git build-essential libncurses5-dev openssl \
libssl-dev libssl0.9.8 libc6-dev libc6-dev
```

Now download the latest erlang release from [here](https://www.erlang-solutions.com/downloads/download-erlang-otp) and set it up as:

``` bash
sudo dpkg -i <your_downloaded_file.deb>
```
If that goes suuccessfully and without a fuss, chances are that you will have a fully functioning riak installation in a jiffy.
Next steps are fairly simple.

``` bash
git clone https://github.com/basho/riak.git
cd riak
make devrel
```

Successful completion of the above indicates you're good. Just in case, let's check our installation.

``` bash
cd dev
dev1/bin/riak start
dev1/bin/riak ping
```
If the output goes pong, you are all set to get your explorer cap on.

In my case, there were lots of head-scratching due to incompatibilities between erlang, riak sources yada yada. Hopefully the process goes smoothly for you. Hoot off below if you are having problems