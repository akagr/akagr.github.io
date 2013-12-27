---
layout: post
title: "Wrapping my head around prototypal inheritance in javascript"
date: 2013-12-27 16:28:40 +0530
comments: true
categories: 
---
Javascript does not have the usual class-object model. I know some C++, some more Java and lots of Ruby. All of them follow classical object model which was kinda etched in my mind now. As such, the object model of javascript took a lot of time for me to wrap my stubborn head around.

So have I mastered it? Not at all. I have just started with serious js and need to practise. But I think I have a fairly good idea of how it works and what goes where. So here goes.

##  So what exactly is a prototype?
Prototype is an object which acts as a base for other objects to inherit from. if that sounds confusing, consider an example. If we have a class named Animal, what will the Human be? If you think Human is also a class, what would your father be? An object? But you inherit from him too, right?

This was the eureka for me when I realized we can do without classes in our life. Object oriented programming was designed to mirror real-world. And there are no classes here. Everything is an object. We can say that two objects are similar, like two people. But this doesn't mean someone 3-d printed them according to a design called class. Those people came from other people, inheriting things, modifying and adding stuff on the way. See it?

{% blockquote %}
In real world, classes don't spawn objects, objects do.
{% endblockquote %}

This outlook feels more natural to me now. And if you want to get the js object model, you need to come at it with an open mind. Don't try and find answers of prototypal model in the classical one and vice-versa.

## So how does it work in javascript?
Let's see some code.

```javascript
function Animal(no_of_legs)
  this.legs = no_of_legs
  this.how_many_legs = function(){
    console.log(this.legs)
  }
}
strange = new Animal(1)
strange
>> { legs: 1, how_many_legs: [Function] }
```
Here's the break-up. Animal is an ordinary function. Don't mind the capital A. Call it what you want. Doesn't matter at all. So what's new? `new` is a keyword which creates a generic object `{}` and runs the given function on it. Nothing fancy. Let's write the last lines of the above examples somewhat differently to show you what I mean.

```javascript
strange = {} // we create a generic object
Animal.call(strange, 1) // we run the function on it
strange
>> { legs: 1, how_many_legs: [Function] } // Voila!
```
See how we mimicked the behavior of `new`? We now have a strange object with a couple of properties. We kinda initilized the object by giving it some pieces to own via `Animal()`. And we have a name for such kind of functions, do we not? We call them constructors. But don't let the name fool you. They really are ordinary functions.

We now know how we can create similar objects by using constructors. Let's create a couple more.

```javascript
normal = new Animal(4)
wtf = new Animal(10)
```
All these animals have common properties namely `legs` and `how_many_legs()`. We can definitely specialize these objects by assigning new un-related properties to each of them individually.

```javascript
strange.name = "Strange"

strange.name
>> 'Strange'

normal.name
>> undefined

wtf.name
>> undefined
```

There is a problem with above code. Each new object has its own copy of `legs` which is necessary to differentiate their states. But they also have their own separate copies of `how_many_legs()` method. Method body remains same for all objects. So how do we share same method object between various animal objects?

## Prototypes
Each function in js is potentially a constructor. Just write a silly one and use `new your_silly_method()` and it will create an object. If your method gives it some properties, fine, otherwise it will still create an empty `{}`. Similarly, each function also has a property called `prototype`. The contents of this property are shared by all the objects created through this function.

{% blockquote %}
Each function has a property called 'prototype'. If the function is used as a constructor to create objects, then the contents of its 'prototype' property will be shared by all those objects.
{% endblockquote%}

This is probably the most important line of this post. Keep it clear in your head. Here's how we use prototypes.

```javascript
function Animal(no_of_legs){
  this.legs = no_of_legs
}
Animal.prototype.how_many_legs = function(){
  console.log(this.legs)
}

strange = new Animal(1)

strange
>> { legs: 1 }

Animal.prototype
>> { how_many_legs: [Function] }

strange.how_many_legs(){
  console.log(this.legs)
}
>> 1
```
See how the `how_many_legs()` function is no more a part of `strange`? Instead it resides in `Animal.prototype` and is thus callable from `strange`.

Experiment a bit with prototypes. If you got your brains around the above concept, you're are already almost there.

## Inheritance. Finally.
So what do we need to implement inheritance. Only a couple of things actually.

1. We need to share the properties of parent with child.
2. A child needs to be able to pass the baton to parent in case something does not exist with it. We will need a pointer of sorts for this.

Here's how we get the first requirement, i.e. share Animal's properties with its children

```javascript
function Human(name, age){
  this.name = name;
  this.age = age;
}

Human.prototype = new Animal(2)

i = new Human("Akash", 23)
```

Now take a moment and think about what all things `you` will have access to. Here's what we have.
```javascript
i.name
>> "Akash" // as expected

i.age
>> 23 // also expected

Human.prototype
>> { legs: 2 } // new Animal(2)

// therefore
i.legs
>> 2 // see it?
```
If you are still with me, you deserve a pat on back. This is the purest most undiluted method of implementing inheritance in javascript. There are other tricks too, but all of them have their roots here. We still have one last thing to see.

```javascript
i.how_namy_legs()
>> 2
```
So how does this work? When interpreter does not find `how_many_legs()` in `i`, it looks it in its prototype. It founds that `i's` prototype is an Animal object which does have access to the said function. You can create a child object of Human and the chain will be continue the same way.

Thanks for reading. Sound off below if you think something's amiss or incorrect.

