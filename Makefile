.PHONY: dev undev test compile

export PATH := ./node_modules/.bin:$(PATH)

dev: undev
	mkdir -p dist # XXX: should not be necessary
	mkdir -p tmp
	`which gulp` autocompile & \
		echo $$! > tmp/autocompile.pid

undev:
	kill `cat tmp/autocompile.pid` || true
	rm tmp/autocompile.pid || true

test:
	`which mocha` --compilers coffee:coffee-script/register

compile:
	`which gulp` browserify
