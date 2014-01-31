---
layout: post
title: "Infinite scroller in AngularJs"
date: 2014-01-31 10:52:03 +0530
comments: true
categories: [js, angularjs]
---
Pagination is necessary. You can't slap 10k records in front of a user. And it is stupid to send that much data across. Even more stupid to expect that user will stick around while your data is received and rendered.

But infinite scrollers are like pagination hopped up on botox. They look beautiful, feel fresh and don't make users wait for silly page loads. What's more? They are generally much easier to build. So lets build one such scroller in angularjs from scratch.

Here's a light bulb. If you don't know when to use directives, look out for places where you need to manipulate DOM from js. This includes adding event listeners, manipulating classes, css etc. These scream directive almost always. Since we will most definitely need to attach at least a scroll event listener to something, directive is what we are going to write.

Let's quickly create a dummy directive which attaches a scroll event to an element and make it alert every time we scroll it. Here is a quick fiddle to tinker with. Note that I have limited the height of scrollable element. Obviously, something needs to be scrollable. Be sure to put the directive on the element on which you are putting a scrollbar. It can be `<body>` itself. Just take care to get the controller right in that case.

{% jsfiddle akagr/Eu2FW %}

See how I have populated the list very crudely to get things going. The interesting points here are the `<ul scroller>` element in html and the directive in js. We have binded an event to the element.

But this list population is really bugging me. Moreover, I believe you'll want to load data on scroll instead of showing alert. So let's quickly refactor our controller and reference it from our directive.

{% jsfiddle akagr/Eu2FW/2 %}

We have stashed away the logic to add more data inside a method which is called once from controller itself to load initial data. Every time we scroll, it adds more data. See the problem yet? We need to load data only when user hits the bottom. And we don't want to load data if user is scrolling up. Notice how scroll bar behavior changes as you scroll more. Try dragging scrollbar manually.

We need some logic to only load data if we have reached bottom. Lets see what we can do.

{% jsfiddle akagr/Eu2FW/4 %}

Now that's more like it. I have marked the new bits with comments. We had some core js methods for DOM elements so we needed to extract it out of jquery wrapped element object. Next we put in a condition so that the `loadMore()` is called only when we are near bottom. Here's what each option means:

  * scrollHeight: This is the total height of the element if it were not of limited height. Imagine all the `<li>` elements stacked without any hidden by overflow.
  * scrollTop: This is the amount of vertical pixels which we have scrolled. If you are at the top, it is 0.
  * offsetHeight: This is the height of the current frame visible to you. (Height of the yellow frame visible to us)

  {% img center http://javascript.info/files/tutorial/browser/dom/elemScroll.png %}

I have added a padding of 5 pixels to make it failsafe. I found sometimes even when I was at bottom, the sum of scrollTop and offsetHeight was lagging behind by a couple of pixels. 

We have a fully functional infinite scrolling directive at this point. However it needs some refactoring. Right now, the directive is coupled with our controller too tight. For ex, it assumes that our controller must be having a `loadMore()` method. We can eliminate this by providing the loading method in html itself. Here's how. Look for additions and changes in comments.

{% jsfiddle akagr/Eu2FW/6 %}

By using isolate scope, we have fully decoupled our directive from controller. We can now use it without any changes across our apps. All we need is to specify the loading method in the html declaration. You can pimp out the `loadMore()` method by using some network calls and fetching stuff from database.

Thanks for sticking through. Hope you enjoyed it.