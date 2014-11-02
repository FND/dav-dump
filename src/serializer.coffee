# inspired by TiddlyWeb's text serialization, which uses an RFC 822-style format
# `tid`s are key-value pairs with two special slots: `title` and `body`
# values enclosed in square brackets are considered comma-separated lists

delimiters =
	headers: ": "
	lists: ", "

# NB: throws errors for invalid headers
exports.serialize = (tid) ->
	headers = []
	for key, value of tid
		if key is "title"
			title = value # discarded
		else if key is "body"
			body = value
		else
			if key.indexOf(delimiters.headers) != -1
				throw "header keys must not contain colon delimiters"
			value = "[#{value.join(delimiters.lists)}]" if value.join
			header = [key, value].join(delimiters.headers)
			if header.indexOf("\n") != -1 # XXX: what about \r?
				throw "headers must not contain line breaks"
			headers.push(header)

	return headers.concat(["", body]).join("\n")

# NB: throws errors for invalid inputs
exports.deserialize = (title, txt) ->
	[headers, body] = part(txt, "\n\n")
	throw "invalid serialization" if undefined in [headers, body]

	headers = headers.split("\n")
	body = body.trim()

	tid = {}
	for line in headers
		[key, value] = part(line, delimiters.headers)
		throw "invalid serialization" if undefined in [key, value]

		if value[0] is "[" and value.substr(-1) is "]"
			value = value[1..value.length-2].split(delimiters.lists)

		tid[key] = value

	tid.title = title
	tid.body = body

	return tid

# split into two parts
part = (str, delimiter) ->
	parts = str.split(delimiter)
	return [] if parts.length < 2
	return [parts[0], parts[1..].join(delimiter)]
