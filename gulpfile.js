"use strict";

var gulp = require("gulp");
var browserify = require("feta/tasks/browserify");
var fs = require("fs");
var path = require("path");

var paths = {
	csEntry: "src/main.coffee",
	distro: "dist",
	js: "bundle.js"
};

var jsExtensions = [".coffee"];

gulp.task("autocompile", function() {
	browserify.watchify(paths.csEntry, path.join(paths.distro, paths.js),
			jsExtensions);
});

gulp.task("browserify", browserify(paths.csEntry,
		path.join(paths.distro, paths.js), jsExtensions));

// auto-install Git hooks
fs.symlink("../../hooks/pre-push", "./.git/hooks/pre-push", function(err) {
	if(err && err.code !== "EEXIST") {
		console.error("ERROR creating symlink");
	}
});
