---
layout: post
title: "AngularJs Directives"
date: 2014-01-28 18:40:24 +0530
comments: true
categories: 
---
I'll be frank. Directives scared the hell out of me. They always seemed like something I needed to know to really put a leash around the angularjs code. But somehow I always found ways not to use them. A couple of variables here and a dozen of functions there. I hacked away ignoring any real need to use directives while the truth always loomed above. I needed to conquer them. Maybe I did, or maybe I cracked. Here's what I learnt on way to either of the two.

Just why the hell should I care about directives?
------------------------------------------------------

Because they could make your code from this:

```html
<ul class="nav nav-tabs" id="myTab">
  <li class="active"><a href="#section1">Section 1</a></li>
  <li><a href="#profile">Section 2</a></li>
</ul>
     
<div class="tab-content">
  <div class="tab-pane active" id="section1">Hi, I'm Section 1</div>
  <div class="tab-pane" id="section2">Hi, I'm Section 2</div>
</div>
          
<script>
  $(function () {
    $('#myTab a:last').tab('show');
  })
</script>
```

to this:

```html
<tabs>
  <pane title="Section 1">
    Hi, I'm Section 1
  </pane>
  <pane title="Section 2">
    Hi, I'm Section 2
  </pane>
</tabs>
```

And this is a very small example, mind.

Ok. You are already convinced. Let's do it.
------------------------------------------------

I will assume you know how to bootstrap an angular app. [Read the docs](http://docs.angularjs.org/tutorial/step_00) to learn how otherwise.

So a general definition of a directive looks something like:

```javascript
app = angular.module('myApp', []);

app.directive('mindBlown', function({
  return {
    //configuration options
  }
}))
```

That's about it. This was the easy part. Lets get down to the meat and see what options we get to pass to create a directive of our dreams.
