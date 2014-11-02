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

	return)
