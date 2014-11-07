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
