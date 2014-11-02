# WebDAV-based file store, managing the contents of an individual directory
# inspired by TiddlyWeb's text store
# `tid`s are key-value pairs identified by `title`

xml = require("./xml")
http = require("./util").http

module.exports = class Store
	# `root` is the base directory's URL
	constructor: (@root) ->
		throw "missing root URL" if @root is undefined

	# returns a promise for a tuple of directories and files
	index: ->
		return http("PROPFIND", @root, Depth: 1).
			then((res) -> xml.extractEntries(res.body))
