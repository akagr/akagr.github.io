---
layout: post
title: "Lazy definitions in javascript"
date: 2014-03-24 15:21:53 +0530
comments: true
categories: ['js']
---
Ifs and elses make me cringe. I try to keep them away from my code since they generally result in lengthy and brittle code. But there are times when you simply don't have a choice. And you hate every moment of it. I learned a new pattern for defining functions lazily which I think is pretty cool. It cuts out these conditionals in a particular scenario and keeps me a little happier. Let's dig in.

<!-- more -->

Use case
----------
This pattern can be applied when you know you'll need to execute a conditional only once and use it's result throughout. Example of this is if you are writing your own wrapper for ajax calls. IE, as always, requires a little something extra. So you may be lured into writing something like this:

```javascript
var myajax = function(){
  /* Detect browser here with user agent or whatever */
  var browser = 'some browser';   
  if(browser === 'ie')
    /* Do it the way microsoft wants you to */
  else
    /* Do it like the rest of this world. */
}
```

There is nothing wrong with this code, if you are using it to teach beginners how to define functions. For production purposes, executing the conditional every time and knowing only one block is executing is always a pain. Sure, you can cache the result of browser and use that as a conditional so you don't have to calculate it again. But still, that conditional won't be leaving anytime soon. Fortunately, javascript doesn't go lightweight on you especially when functions are involved.

Solution
-------------
```javascript
var myajax  = (function () {
  /* Detect browser here with user agent or whatever */
  var browser = 'some browser'; 
  var result;
  if(browser === 'ie'){
    result = function(){
      /* This way ie */
    };
  }
  else {
    result = function() {
      /* Chrome, FF, what have you */  
    }
  }
  return result;
})();
```

Now that may look like more code than the previous snippet, but let's do a dry run. Based on the browser detected, `myajax` would contain code related to that browser only. Thereafter, there will be no conditionals for checking browser, no calculating browser from user agent, no nothing. Suddenly, our ajax wrapper loses all fat and starts eating less cpu cycles doing comparison it already should know an answer to.

I hope the code was easy to follow. It wasn't much anyways. Think you'll use it sometime soon?

Thanks for reading.
