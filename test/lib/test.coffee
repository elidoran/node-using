assert = require 'assert'
use = require '../../lib'



describe 'test errors', ->

  it 'should return an error for unknown module', ->

    thing = {}
    thing.use = use
    result = thing.use 'unknown-module-name'
    assert.equal result?.error, 'Unable to require plugin with string: unknown-module-name'

  it 'should return an error for non-existent path', ->

    thing = {}
    thing.use = use
    result = thing.use '/does/not/exist'
    assert.equal result?.error, 'Unable to require plugin with string: /does/not/exist'

  it 'should return an error for a non-function', ->

    thing = {}
    thing.use = use
    result = thing.use [] # not a string or function
    assert.equal result?.error, 'plugin must be a function'


describe 'test default use()', ->

  it 'should add a property', ->

    thing = {}
    thing.use = use
    thing.use -> @prop = 'test'
    assert.equal thing.prop, 'test'

describe 'test use.withOptions()', ->

  it 'should add the specified property', ->

    thing = {}
    thing.use = use.withOptions prop:'test'
    thing.use (options) -> @[options.prop] = 'test'
    assert.equal thing.test, 'test'


describe 'test plugin options', ->

  it 'should add the property specified in plugin options', ->

    thing = {}
    thing.use = use
    thing.use ((options) -> @[options.prop] = 'test'), prop:'plugin'
    assert.equal thing.plugin, 'test'

  it 'should use plugin options prop instead of withOptions() prop', ->

    thing = {}
    thing.use = use.withOptions prop:'test'
    thing.use ((options) -> @[options.prop] = 'test'), prop:'plugin'
    assert.equal thing.plugin, 'test'
