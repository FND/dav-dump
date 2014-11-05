.PHONY: dist dev undev test dist_dir

export PATH := ./node_modules/.bin:$(PATH)

dist: dist_dir
	`which gulp` browserify

dev: undev dist_dir
	mkdir -p tmp
	`which gulp` autocompile & \
		echo $$! > tmp/autocompile.pid

undev:
	kill `cat tmp/autocompile.pid` || true
	rm tmp/autocompile.pid || true

test:
	`which mocha` --compilers coffee:coffee-script/register

# XXX: should not be necessary (i.e. handled by the respective gulp tasks)
dist_dir:
	mkdir -p dist
