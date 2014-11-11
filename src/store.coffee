# WebDAV-based file store, managing the contents of an individual directory
# inspired by TiddlyWeb's text store
# "tids" are key-value pairs identified by `title`

serializer = require("./serializer")
xml = require("./xml")
util = require("./util")

module.exports = class Store
	# `root` is the base directory's URL
	# `http` is a function as described in the corresponding module
	constructor: (@root, @http) ->
		@_cache = null
		throw "missing root URL" if @root is undefined

	# returns a promise for updated tids index (i.e. same as `#all`)
	add: (tid) -> # XXX: subject to race conditions (conflicts)
		put = @http("PUT", @uri(tid.title), { "Content-Type": "text/plain" },
				serializer.serialize(tid))
		return Promise.all([put, @all()]).
				then(=>
					@_cache[tid.title] = util.clone(tid, true)
					return util.clone(@_cache, true))

	remove: (title) ->
		return @http("DELETE", @uri(title))

	# XXX: awkward signature; assumes tid is being moved between store instances
	#      within the same WebDAV host (thus also not allowing for renaming)
	move: (title, targetStore) ->
		return @http("MOVE", @uri(title), Destination: targetStore.uri(title))

	# `ignoreCache` triggers a full update, resetting the cache
	# returns a promise for tids indexed by title
	all: (ignoreCache) -> # TODO: rename?
		return Promise.resolve(@_cache) if @_cache and !ignoreCache

		return @index().then(([dirs, files]) =>
			tids = (@get(title) for title in files)
			return Promise.all(tids).
				then((tids) =>
					@_cache = util.indexBy("title", tids)
					return util.clone(@_cache, true)))

	# `ignoreCache` triggers a full update, resetting the cache
	# returns a promise for the respective tid
	get: (title, ignoreCache) ->
		if @_cache and !ignoreCache
			tid = @_cache[title]
			return Promise.resolve(tid) if tid

		return @http("GET", @uri(title)).
			then((res) ->
				tid = serializer.deserialize(title, res.body)
				@_cache[tid.title] = tid if @_cache
				return  util.clone(tid, true))

	# returns a promise for a tuple of directories and files
	index: ->
		return @http("PROPFIND", @root, Depth: 1).
			then((res) -> xml.extractEntries(res.body))

	uri: (title) ->
		root = if @root is "/" then "" else @root # XXX: special-casing; smell!?
		filename = encodeURIComponent(title)
		return [root, filename].join("/")
