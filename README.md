# using
[![Build Status](https://travis-ci.org/elidoran/node-using.svg?branch=master)](https://travis-ci.org/elidoran/node-using)
[![Dependency Status](https://gemnasium.com/elidoran/node-using.png)](https://gemnasium.com/elidoran/node-using)
[![npm version](https://badge.fury.io/js/using.svg)](http://badge.fury.io/js/using)

Add use() function for easy plugin ability.

Allows default options and plugin specific options.

Accepts module name or path to `use()` and will `require()` it for you.

Can assign it to any name.


## Install

```sh
npm install using --save
```


## Usage: Applying 'using'

The simplest way to use this module is to `require()` it and assign it to the `use` property on your object.

You may use any property name, like, 'load', 'add', 'plugin', or 'enhance'.

Use it by supplying something which can be given to `require()` to get a function, or, supply a function.

```javascript
// your thing can be anything we can set `use` on
var thing = getThing()
// get this module which is the `use()` function
  , use = require('using')

// set it on your thing. can name it anything you want.
thing.use = use

var somePluginName = 'some-name'
  , pluginRequired = require('another-plugin')
  , pluginFunction = function() { }
  , someOptions = {}

// add those plugins to your `thing`:
//  Note: options are optional

// 1. provide a module name or file path for `require()`
thing.use(somePluginName, someOptions)

// 2. provide the module directly when you've already loaded it
thing.use(pluginRequired, { /* Or, some other options */ })

// 3. provide a function directly as a plugin
thing.use(pluginFunction /* Or, no options */)
```


## Usage: Example Plugin

```javascript

function plugin(options, thing) {
  // `this` is the `thing`, same as param #2.
  // so, these two lines do the same thing:
  this.blah = 'example'
  thing.blah = 'example'

  // `options` is the combined options provided to:
  //   1. `thing.use = using.withOptions(defaultOptions)`
  //   2. `thing.use(fn, pluginOptions)`
  // #2 overrides #1.
}
```


## Usage: Example

```javascript
// example `thing` is a behaviorless object
var thing = {}

// add this module so plugins can be applied
thing.use = require('using')

// add a function directly as a plugin.
// it adds a function to the `thing`
thing.use(function addProcess() {
  // `this` is the `thing`
  this.process = function process(string) {
    console.log('I am processing string:', string)
  }
})

// now `thing` has added ability.
// the below call will output to the console:
//   I am processing string: blah
thing.process('blah')

// add another function which will alter process()
thing.use(function wrapInput(options) {
  var realProcess = this.process
    , prefix = '['
    , suffix = ']'

  if (options) {
    if (options.prefix) prefix = options.prefix
    if (options.suffix) suffix = options.suffix
  }

  this.process = function wrappedProcess(string) {
    string = prefix + string + suffix
    return realProcess.call(this, string)
  }
})

// now `process()` wraps the string with brackets instead
// the below call will output to the console:
//   I am processing string: [bleh]
thing.process('bleh')
```


## Usage: Specify Default Options

```javascript
// as above, let's use a behaviorless object
var use = require('using')
  , thing = {}

// instead of adding the default `use()` function, let's supply options.
thing.use = use.withOptions({
  // these will be used by `wrapInput`
  prefix: '(',
  suffix: ')'
})

// same as the functions made above
thing.use(addProcess)
thing.use(wrapInput)

thing.process('blarg')
// The `wrapInput` will receive the options we made
// and then use parenthesis instead of brackets.
// the above outputs this to the console:
//    I am processing string: (blarg)
```

## Usage: Specify Plugin Options

```javascript
// as above, let's use a behaviorless object
var thing = {}

// instead of adding the default `use()` function, let's supply options.
thing.use = require('using').withOptions({
  // these will be overridden by plugin specific options
  prefix: '(',
  suffix: ')'
})

// same as the functions made above
thing.use(addProcess)
// these plugin specific options will override default options
thing.use(wrapInput, {
  prefix: '\'',
  suffix: '\''
})

thing.process('bling')
// The `wrapInput` will receive options combined from the default
// options provided for the `use()` function
// and the plugin specific options provided to the `use()` call,
// So, it will use single quotes instead of brackets or parenthesis.
// the above outputs this to the console:
//    I am processing string: 'bling'
```


## MIT License
