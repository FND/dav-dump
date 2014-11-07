# interface to be implemented by a specific adaptor
# `headers` and `body` are optional
# return value is a promise for `{ status, headers, body }`, with `status` being
# an integer and `body` automatically being converted to an XML document based
# on the response's content type
http = (method, uri, headers, body) ->
