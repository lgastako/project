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

help: build
	$(BINARY) --help

b: build
r: run
h: help
