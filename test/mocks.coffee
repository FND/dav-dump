DOMParser = require("xmldom").DOMParser
Promise = require("promiscuous") # TODO: use native implementation when available
util = require("../src/util")
getFixture = require("./util").getFixture

responses =
	"PROPFIND /":
		status: 207
		headers:
			"Content-Type": 'text/xml; charset="utf-8"'
		body: getFixture("index.xml")

util.http = (method, uri, headers, body) ->
	new Promise((resolve, reject) ->
		onResponse = ->
			res = responses["#{method} #{uri}"]
			if res
				resolve({
					status: res.status,
					headers: res.headers,
					body: parse(res.body, res.headers["Content-Type"])
				})
			else
				reject(status: 404, headers: {})
		setTimeout(onResponse, 10)
		return)

parse = (str, contentType) ->
	return str unless contentType
	contentType = contentType.split(";")[0]
	if contentType is "text/xml"
		return new DOMParser().parseFromString(str, contentType)
	else
		return str
