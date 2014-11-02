assert = require("assert")
srz = require("../src/serializer")

describe("serialization", ->
	it("should generate a text representation of a tiddler-like object", ->
		tid =
			title: "Hello World"
			body: "lorem ipsum\ndolor sit amet"
		assert.strictEqual(srz.serialize(tid),
				"""

				lorem ipsum
				dolor sit amet
				""")

		tid.priority = "high"
		assert.strictEqual(srz.serialize(tid),
				"""
				priority: high

				lorem ipsum
				dolor sit amet
				""")

		tid.tags = ["foo", "bar"]
		assert.strictEqual(srz.serialize(tid),
				"""
				priority: high
				tags: foo, bar

				lorem ipsum
				dolor sit amet
				""")

		tid =
			title: "Hällo Wörld"
			body: "lörem ipsüm\ndolor ßit ämet"
			priority: "häü"
			tags: ["föü", "bäß"]
		assert.strictEqual(srz.serialize(tid),
				"""
				priority: häü
				tags: föü, bäß

				lörem ipsüm
				dolor ßit ämet
				""")

		return)

	it("should complain about invalid headers", ->
		tid =
			title: "..."
			body: "..."
			lipsum: "lorem ipsum\ndolor sit amet"
		try
			srz.serialize(tid)
			assert(false)
		catch err
			assert(err is "headers must not contain line breaks")

		tid =
			title: "..."
			body: "..."
		tid["lorem ipsum\ndolor sit amet"] = "..."
		try
			srz.serialize(tid)
			assert(false)
		catch err
			assert(err is "headers must not contain line breaks")

		tid =
			title: "..."
			body: "..."
		tid["foo:bar"] = "..."
		try
			srz.serialize(tid)
			assert(false)
		catch err
			assert(err is "header keys must not contain colons")

		return)

	return)

describe("deserialization", ->
	it("should create a tiddler-like object from its text representation", ->
		try
			srz.deserialize("Hello World", "")
			assert(false)
		catch err
			assert(err is "invalid serialization")

		try
			srz.deserialize("Hello World",
					"""
					lorem ipsum
					""")
			assert(false)
		catch err
			assert(err is "invalid serialization")

		try
			srz.deserialize("Hello World",
					"""
					foobar

					lorem ipsum
					""")
			assert(false)
		catch err
			assert(err is "invalid serialization")

		try
			srz.deserialize("Hello World",
					"""
					foo:

					lorem ipsum
					""")
			assert(false)
		catch err
			assert(err is "invalid serialization")

		txt = "foo: \n\n..."
		tid =
			title: "Hello World"
			body: "..."
			foo: ""
		assert.deepEqual(srz.deserialize("Hello World", txt), tid)

		txt = """
			priority: häü

			lörem ipsüm
			dolor ßit ämet
			"""
		tid =
			title: "Hällo Wörld"
			body: "lörem ipsüm\ndolor ßit ämet"
			priority: "häü"
		assert.deepEqual(srz.deserialize("Hällo Wörld", txt), tid)

		return)

	return)