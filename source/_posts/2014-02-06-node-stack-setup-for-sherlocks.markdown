---
layout: post
title: "Node stack setup for sherlocks"
date: 2014-02-06 15:51:48 +0530
comments: true
categories: ['nodejs', 'js']
---
It is really commendable how things like [Yeoman](http://yeoman.io/) can get you up and running with all the boilerplate written for you. That too with almost any combination of front-end, testing and node framework there is. However, make no mistake. If you are learning, better start raw. When I generated my first angularjs node app with yo, I was literally overwhelmed with all the stuff it wrote for me. I didn't understand half of it and deleted the directory promptly. I have been reading good things about various tools (grunt, express, mocha) from sidelines and suddenly, jumping into a couple of hundred line long Gruntfile being a noob was unnerving.

<!-- more -->
If you are like me and like to know how every bit of code in front of you works, let's create a boilerplate seed project ourselves. You really should feel the need to use something like yeoman and should know exactly what it gives you. I will be setting up a dev environment from scratch comprising of

1. ExpressJs (Backend)
2. Angularjs (Front-end)
3. Mocha with Chai (Testing)
4. Grunt (Automation)

First thing we need is to install node and npm. Google it. This bit is easily found. Then come back and we will start with our app.

```bash
nvm install -g express
nvm install -g grunt-cli
nvm install -g bower
```

We installed some node packages here. The `-g` flag means that they are global packages accessible throughout system. First is express. There are really loads of node frameworks including derby, sails etc. I found express to be most production-ready, least opinionated and most easy to setup. Then there is grunt. I'll leave that to a little later. Bower is to front-end what npm is to backend. Bootstrap? Foundation? jQuery? Well, bower takes care of them. I'd have really loved if npm gave us those too. But those are the things we get right now so better suck it.

```bash
express myapp
cd myapp
```
This command basically creates a skeleton of your app and adds a couple of important files. First is `package.json`. You define all your app dependencies and other metadata. This is done so anyone with this file can install exactly the same versions of all dependencies and not be worried of incompatibilities. You'll find there are only a couple of dependencies here. First is express itself and other is jade. Jade is our html preprocessor which allows us to write cleaner markup without all those angle brackets. These files are converted to html when being served to browser.

Run `npm install` and it will install all the dependencies listed in `package.json`. You'll find that a new directory `node_modules` has sprouted up. This contains all the things installed by the command.

The `app.js` is fairly lengthy and is the starting point of your app. You configure settings, setup routes and create a server. To understand what each line does, I suggest you read the [api reference](http://expressjs.com/api.html) which is surprisingly detailed yet short. Other than those, there is not much express really adds to your app. Just a couple of really small routes and views so that you can run `node app.js` and be happy. Well go ahead and run it.

Next we install a couple of front-end dependencies such as angularjs and foundation to start with. We will user bower for that. First we need a `bower.json` which, like `package.json` will keep a record of all things front-end for us.

``` bash
bower init
```
This will make you answer half a dozen questions and will spit back the final file. We will be editing the newly created `bower.json` to add some packages.

```json bower.json
{
  "name": "myapp",
  "version": "0.0.1",
  "authors": [
    "Akash Agrawal <akagr@outlook.com>"
  ],
  "main": "app.js",
  "license": "MIT",
  "private": true,
  "ignore": [
    "**/.*",
    "node_modules",
    "bower_components",
    "test",
    "tests"
  ],
  "dependencies": {
    "angular" : "~1.2.11",
    "foundation" : "~5.0.3"
  }
}
```
We run a quick `bower install` and welcome a new `bower_components` directory to our app. Feel free to explore it.

If you have done some development, you can certainly name some tasks you'd rather have oompa-loompas for. Like minifying your scripts and css, running tests everything you change something etc. Well grunt is the answer to all of these and since it can actually make your workflow go from bad to rad, I'll try to look at it in some depth. Let's install grunt locally to our project.

```bash
npm install grunt --save
```
The `--save` option install the grunt and adds it to your package.json with correct version and everything. Sweet!

Grunt is, at its heart, a task runner. You tell it what to run, provide it some configuration options if applicable and it will see to it that the task is run. Go ahead and run `grunt` in terminal. It will complain that there is no Gruntfile. We need to make one. `touch Gruntfile.js` ought to do it. Run the grunt again. Now it will complain about not finding any tasks named 'default'. Basically, we run the grunt like `grunt taskname`. If we omit taskname, it looks for a task named `default`. Let's hook up our Gruntfile. It has the following basic structure.

```js Gruntfile.js
module.exports = function (grunt) {
  
  /* A gruntfile has three impotant parts*/

  /* 1. Configuration: This part specifies the options 
                       and configs for the tasks which 
                       can be run by grunt. Plus it has'
                       some grunt specific config too. */

  /* 2. Loading: We load tasks from other files and plugins
                 so that they are visible to grunt. Grunt does
                 not see your node_modules bu itself. If you
                 install a task package, you need to include it
                 here. Normally one line for each task package or file /*

  /* 3. Registration: You can register custom tasks here. For example:
                      `grunt develop` may run tests, start a server and
                      watch files for changes. You tell that combination here. */
   
}
```

Let's fill out each part one by one. First we define some configuration options.

```js
grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    jshint: {
      files: ['Gruntfile.js', 'app.js']
    },

    watch: {
      files: ['<%= jshint.files%>'],
      tasks: ['jshint']
    }

  });
```
Substitute the above in place of the comment of first part of Gruntfile. We added options for jshint and watch. Jshint will only act on the files we specify but we shouldn't need to run it everytime we modify these files. Therefore we added a watch which will monitor all the files specified by jshint task and run jshint whenever it notices any changes. Let's run `grunt watch` and see what happens. It didn't find the task watch. Remember , this part only contains the options to the tasks; not the actual tasks. We need to install those via npm and load them in our gruntfile.

```bash
npm install grunt-contrib-watch --save-dev
npm install grunt-contrib-jshint --save-dev
```
That installed both the packages in `node_modules`. Notice the different `--save-dev` flag? It means package is a development dependency and not needed in production environment. We may choose not to install it on production server. Only add utility packages here on which your app's functionalilty does not depend. Now we reference both these packages from our Gruntfile. Substitute the second part of the comments with the following.

```js
grunt.loadNpmTasks('grunt-contrib-jshint');
grunt.loadNpmTasks('grunt-contrib-watch');
```

Nothing fancy here. Run `grunt watch`. Bingo! The task started! Trying removing a semicolon from a line in your gruntfile and saving it. Then check back if the watch notices it. Here is the output of my terminal:
```bash
Running "watch" task
Waiting...OK
>> File "Gruntfile.js" changed.

Running "jshint:files" (jshint) task
Linting Gruntfile.js ...ERROR
[L31:C2] W033: Missing semicolon.
} 

Warning: Task "jshint:files" failed. Use --force to continue.
```

We are golden! The thing is set up correctly and killing it. The watch task is my most loved task. I can watch for anything and do anything. Kinda like demigod. Now lets quickly register a default task and make out Gruntfile complete. Use the following in place of the third placeholder comment.

```javascript
grunt.registerTask('default', ['watch']);
```

Now, kill the grunt if it is running and invoke it using just `grunt`. See what I mean. You can define loads of cool combinations like `'production', ['jshint', 'mochatest', 'uglify', 'concat']` and reap the benefits of automation.

Since we haven't written any application code yet, it would be a good time to set up testing and automate it with our newfound knowledge. I really liked mocha as testing framework. So here goes.

```bash
npm install grunt-mocha --save-dev
npm install grunt-mocha-test --save-dev
npm install chai --save-dev
```

We need a sample test to make sure things are working. Create a directory `test` and add a new file `sample.test.js`. Use the following code for starters.

```js
var expect = require('chai').expect;

describe("Testing sample", function(){
  it("should run successfully", function(){
    expect(1+1).to.equal(2);
  });
});
```
Now back to our Gruntfile. We need to specify some options, load the plugins and add a watch over them. Here is what my Gruntfile looks after this.

```js Gruntfile.js
module.exports = function (grunt) {
  
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    jshint: {
      files: ['Gruntfile.js', 'app.js']
    },

    mochaTest: {
      test: {
        options: {
          reporter: 'spec'
        },
        src: ['tests/**/*.js']
      }
    },

    watch: {
      files: ['<%= jshint.files%>', 'tests/**/*.js'],
      tasks: ['jshint', 'mochaTest']
    }

  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-mocha-test');

  grunt.registerTask('default', ['watch']);
   
};
```

Now you can either run the tests through `grunt mochaTest` or begin `grunt` and watch them execute on any changes. Both are handy to have.

So that's that. I hope the post was of some value and actually lit some bulbs in your head as to what goes where. Pimp out your Gruntfile some more, write some failing tests and make them pass. You know the way from here. Sound off below if something's amiss. Thanks for reading.
