# utilities for handling WebDAV XML documents

# extract file names from PROPFIND response
exports.extractEntries = (doc) ->
	dirs = []
	files = []
	for entry, i in doc.getElementsByTagNameNS("DAV:", "response")
		entry = parseEntry(entry)
		continue if i is 0 # skip root -- XXX: brittle?
		list = if entry.dir then dirs else files # TODO: use `reduce` instead?
		list.push(entry.name)

	return [dirs, files]

parseEntry = (entry) ->
	uri = entry.getElementsByTagNameNS("DAV:", "href")[0].textContent
	uri = uri.replace(/\/$/, "") # trim trailing slash
	name = uri.split("/").pop()

	entry =
		name: decodeURIComponent(name)
		dir: !!traverse(entry, "propstat", "prop", "resourcetype", "collection")
	return entry

traverse = (root, path...) -> # TODO: rename
	node = root
	while(path.length)
		part = path.shift()
		return null unless node
		node = node.getElementsByTagNameNS("DAV:", part)[0]
	return node
