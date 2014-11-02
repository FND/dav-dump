assert = require("assert")
Store = require("../src/store")
require("./mocks")

describe("store", ->
	it("should provide a directory index", (done) ->
		store = new Store("/")
		store.index().
			then(([dirs, files]) ->
				assert.deepEqual(dirs, ["meta"])
				assert.deepEqual(files, ["föü", "bäß"])
				done()).
			catch(done)
		return)

	it("should provide contents indexed by title", (done) ->
		store = new Store("/")
		expected =
			föü:
				title: "föü",
				tags: ["aaa", "bbb"]
				body:"lorem ipsum"
			bäß:
				title: "bäß"
				priority: "high"
				body: "dolor\nsit amet"
		store.all().
			then((tids) ->
				assert.deepEqual(tids, expected)
				done()).
			catch(done)
		return)

	return)
