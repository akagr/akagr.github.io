---
layout: post
title: "How to write asynchronous javascript"
date: 2014-05-21 14:48:45 +0530
comments: true
categories: ['js']
---

There is a high chance that any article you read on javascript mentions something about asynchronous nature of the language. But what exactly makes the language async? Or, in other words, how can we write asynchronous code? If you have tried accepting methods as arguments to make it **look** async, you'll know it won't work. If you have not, let's quickly build an async-looking method and see how it rolls.

I will go with the most naive implementation of fibonacci since a reasonably high number will be sufficient to lock our program and show if our code is running async.

```javascript
var fibonacci = function(num) {
  if(num <= 1){
    return 1;
  }
  else{
    return fibonacci(num - 1) + fibonacci(num -2)
  }
};

var my_async_method = function(num, callback){
  /* Calculate the fibonacci number for the given argument */
  var result = fibonacci(num);

  /* Call the given callback with the result */
  callback(result);
}

my_async_method(40, function(res){
  console.log("Marker 1: Fibonacci returned: " + res);
});

console.log("Marker 2: This line prints when the above method completes");
```

If we go ahead and run the above code, we'll notice a lag before the result and subsequently our markers are printed (otherwise pass a larger number). Another point of interest is that marker#2 had to wait for the execution of `my_async_method` to finish before it. Although our invocation of `my_async_method` looks async, it clearly isn't .

To make a method truly asynchronous, we have to involve native code to break free from the control flow of our code. That means lot of low level C or even Assembly language. But those are not the only options. We can also cover our code inside one of the inherently async methods javascript has on offer. Methods such as `setTimeout`, `setInterval` and `process.nextTick`(node) are some of the async methods. Any code written in these will always execute asynchronously. Period.

Let me give an idea of how we will make our own method to run asynchronously.

```javascript
var my_async_method = function(num, callback){
  /* See what I am doing here? */
  setTimeout(function(){
    /* Calculate the fibonacci number for the given argument */
    var result = fibonacci(num);

    /* Call the given callback with the result */
    callback(result);
  }, 0);
};
```

If we run the code with this version of method, the second marker is executed immediately. After that, when the fibonacci data is calculated and available, our callback is executed. Like a real asynchronous method, right?

This may not sound like a big deal. But I was regularly stumped when some methods behaved asynchronously when mine never did. If you ever wondered the same thing, maybe now you know the magic behind it. Just place your potential bottlenecks inside an asynchronous method and enjoy the real power of async javascript.

Sound of below if this post helped you or you want to suggest corrections/improvements.
