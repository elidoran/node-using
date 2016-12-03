use = (defaultOptions, plugin, options) ->

  if defaultOptions?
    if options? then options.__proto__ = defaultOptions
    else options = defaultOptions

  if typeof plugin is 'string'
    try
      plugin = require plugin
    catch error
      return error:'Unable to require plugin with string: '+plugin, reason:error

  if typeof plugin isnt 'function' then return error:'plugin must be a function'

  plugin.call this, options, this

withOptions = (defaultOptions) ->
  (plugin, options) -> use.call this, defaultOptions, plugin, options

module.exports = withOptions()

module.exports.withOptions = withOptions
