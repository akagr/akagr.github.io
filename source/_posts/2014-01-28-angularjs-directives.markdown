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

I will assume you know how to bootstrap an angular app. [Read the docs](http://docs.angularjs.org/tutorial/step_00) to learn how otherwise. I have provided jsbins along the article so feel free to tinker.

So a general definition of a directive looks something like:

```coffeescript
app = angular.module 'myApp', []

app.directive 'mindBlown', () ->
  return {
    # configuration options
  }
```

That's about it. This was the easy part. Lets get down to the meat and see what options we get to pass to create a directive of our dreams.

**restrict**: Takes `EAMC`(default) individually or in any combination. This option defines how your directive can be declared in markup. 

```coffeescipt
restrict: 'A' # The directive can appear as attribute: <div id="yada-yada" mindblown>
restrict: 'E' # The directive can appear as element: <mindblown> yada-yada </mindblown>
restrict: 'C' # The directive can appear as class name: <span class="yada-tada mindblown"/>
restrict: 'M' # The directive can appear as comment: <!-- directive:minblown -->
restrict: 'AE' # The directive can appear as both an element or/and an attribute. You get the idea?
```

**replace**: Takes `true` or `false`(default). It is used with either `template` or `templateUrl`. It controls whether the given template is substituted inside the directive element or the directive element itself is replaced by the given template.

**template**: Takes valid html markup as string.

Here is a bin to drive the above concepts home. Inspect the output in your favorite html inspector to get the drift.

  {% jsbin APujiXI html,js,output %}

**templateUrl**: Writing html markup may pollute your code especially if it is lengthy. You can create an html file with the required markup and reference it from here. Obviously you should use only one of `template` or `templateUrl`.

**priority**: During the compiling phase, angularjs compiles all the directives (built-in and custom) and links them where applicable. If we want to control the order of compilation of our directives, we can supply optional integer value to priority. Lower value means higher priority.

Here is an example scenario of when it might be needed.

  {% jsbin izuwOgAH html,js,css,output 4 %}

**terminal**: This is one which I haven't found any use for yet. It will prevent directives with priority greater than itself from executing. I can't think of a scenario to show this one so feel free to hack away inside any given bins.

**transclude**: This option lets you substitute the contents of the directive element inside the template you are rendering. This option requires either template or templateUrl for correct fuctioning. Plus you need to specify where you want to substitute the contents in template with the help of `ng-transclude` directive.

  {% jsbin InideRIW html,js,output %}

**controller**: Lets you specify the controlling station of your directive. It is here that you should do any manipulations. The controller is defined as:

```coffeescript
app.directive 'myDirective', () ->
  # other options
  controller: ($scope, $element, $attrs) ->
    $scope.myvalue = 'yay!'
    this.anotherValue = "al'right!"
  #other options
```
Note that the `$scope` in the controller here refers to the scope specified as an option (we'll look at that in a bit). Also while setting values on `$scope` will function just like you think, setting values on `this` will make them available in other directives if we wish. i.e. we can share stuff between directives. The next option shows how.

**require**: Let's you require a controller from other directives. It follows two forms:

```coffeescript
require: '?myDirective' #looks for the directive on same element and will not raise error if no such directive found
require: '^myDirective' #looks for directive on parent element if not found in same element
```
{% jsbin EqUxigiX html,js,output %}
