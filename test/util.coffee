fs = require("fs")
path = require("path")

exports.getFixture = (filename) ->
	filepath = path.join(__dirname, "fixtures", filename)
	return fs.readFileSync(filepath).toString()

