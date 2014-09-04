RACO=raco

BINARY=./project.app/Contents/MacOS/project

all:
	@cat Makefile

clean:
	\rm -rf ./project.app

$(BINARY): project.rkt
	$(RACO) exe --gui project.rkt

build: $(BINARY)

run: build
	$(BINARY)

run-example: build
	$(BINARY) foo bar baz bif

help: build
	$(BINARY) --help

b: build
r: run
rx: run-example
h: help
