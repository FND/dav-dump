DOMParser = require("xmldom").DOMParser
global.Promise = require("promiscuous") # TODO: use native implementation when available
getFixture = require("./util").getFixture

responses =
	"PROPFIND /":
		status: 207
		headers:
			"Content-Type": 'text/xml; charset="utf-8"'
		body: getFixture("index.xml")
	"GET /f%C3%B6%C3%BC": # "föü"
		status: 200
		body: """
			tags: [aaa, bbb]

			lorem ipsum
			"""
	"GET /b%C3%A4%C3%9F": # "bäß"
		status: 200
		body: """
			priority: high

			dolor
			sit amet
			"""
	"PUT /s%C3%A4mple": # "sämple"
		status: 204

exports.http = (method, uri, headers, body) ->
	new Promise((resolve, reject) ->
		onResponse = ->
			res = responses["#{method} #{uri}"]
			headers = res.headers or {}
			if res
				resolve({
					status: res.status
					headers: headers
					body: parse(res.body, headers["Content-Type"])
				})
			else
				reject(status: 404, body: "#{uri} not found")
		setTimeout(onResponse, 1)
		return)

parse = (str, contentType) ->
	return str unless contentType
	contentType = contentType.split(";")[0]
	if contentType is "text/xml"
		return new DOMParser().parseFromString(str, contentType)
	else
		return str
