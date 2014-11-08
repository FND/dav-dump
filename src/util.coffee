exports.indexBy = (prop, items) ->
	reducer = (memo, item) ->
		key = item[prop]
		memo[key] = item
		return memo
	return items.reduce(reducer, {})

# XXX: insufficiently generic
exports.clone = (obj, deep) ->
	return obj unless obj? or typeof obj isnt "object"

	clone = {}
	clone[key] = value for own key, value of obj
	return clone
