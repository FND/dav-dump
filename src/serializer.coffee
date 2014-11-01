# inspired by TiddlyWeb's text serialization, which uses an RFC 822-style format
# `tid`s are key-value pairs with two special slots: `title` and `body`

exports.serialize = (tid) ->
	headers = []
	for key, value of tid
		if key is "title"
			title = value # discarded
		else if key is "body"
			body = value
		else
			if key.indexOf(":") != -1
				throw "header keys must not contain colons"
			value = value.join(", ") if value.join
			header = [key, value].join(": ")
			if header.indexOf("\n") != -1 # XXX: what about \r?
				throw "headers must not contain line breaks"
			headers.push(header)

	return headers.concat(["", body]).join("\n")
