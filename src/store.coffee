# WebDAV-based file store, managing the contents of an individual directory
# inspired by TiddlyWeb's text store
# "tids" are key-value pairs identified by `title`

serializer = require("./serializer")
xml = require("./xml")
util = require("./util")

http = util.http

module.exports = class Store
	# `root` is the base directory's URL
	constructor: (@root) ->
		throw "missing root URL" if @root is undefined

	# returns a promise for tids indexed by title
	all: -> # TODO: rename?
		return @index().then(([dirs, files]) =>
			tids = (@get(title) for title in files)
			return Promise.all(tids).
				then((tids) -> util.indexBy("title", tids)))

	# returns a promise for the respective tid
	get: (title) ->
		return http("GET", @uri(title)).
			then((res) => serializer.deserialize(title, res.body))

	# returns a promise for a tuple of directories and files
	index: ->
		return http("PROPFIND", @root, Depth: 1).
			then((res) -> xml.extractEntries(res.body))

	uri: (title) ->
		root = if @root is "/" then "" else @root # XXX: special-casing; smell!?
		filename = encodeURIComponent(title)
		return [root, filename].join("/")
