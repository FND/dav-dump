# interface to be overridden by a specific adaptor
# expected return value is a promise for `{ status, headers, body }`, with
# `status` being an integer and `body` being automatically converted to an XML
# document based on the response's content type
exports.http = (method, uri, headers, body) ->

exports.indexBy = (prop, items) ->
	reducer = (memo, item) ->
		key = item[prop]
		memo[key] = item
		return memo
	return items.reduce(reducer, {})

exports.clone = (obj, deep) ->
	return obj unless obj and typeof obj is "object"

	clone = {}
	clone[key] = obj[key] for key of obj
	return clone
