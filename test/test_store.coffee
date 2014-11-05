assert = require("assert")
Store = require("../src/store")
require("./mocks")

describe("store", ->
	it("should handle updates", (done) ->
		store = new Store("/")
		tid =
			title: "sämple",
			body: "lörem ipsüm"

		store.add(tid).
			then((tids) ->
				titles = Object.keys(tids).sort()
				assert.deepEqual(titles, ["bäß", "föü", "sämple"])
				assert.deepEqual(tids["sämple"].body, "lörem ipsüm")
				return).
			then(-> tid.body = "dolör sit ämet").
			then(-> store.add(tid)). # explicit update via API
			then((tids) ->
				assert.deepEqual(tids["sämple"].body, "dolör sit ämet")
				done()).
			catch(done)

		return)

	it("should provide contents indexed by title", (done) ->
		store = new Store("/")
		expected =
			föü:
				title: "föü",
				tags: ["aaa", "bbb"]
				body: "lorem ipsum"
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

	it("should retrieve individual tids", (done) ->
		store = new Store("/")
		store.get("föü").
			then((tid) ->
				assert.deepEqual(tid.tags, ["aaa", "bbb"])
				assert.strictEqual(tid.body, "lorem ipsum")
				done()).
			catch(done)
		return)

	it("should provide a directory index", (done) ->
		store = new Store("/")
		store.index().
			then(([dirs, files]) ->
				assert.deepEqual(dirs, ["meta"])
				assert.deepEqual(files, ["föü", "bäß"])
				done()).
			catch(done)
		return)

	return)
