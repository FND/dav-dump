# interface to be overridden by a specific adaptor
# expected return value is a promise for `{ status, headers, body }`, with
# `status` being an integer and `body` being automatically converted to an XML
# document based on the response's content type
exports.http = (method, uri, headers, body) ->
