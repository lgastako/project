RACO=raco

BINARY=./project

INSTALL_DIR=~/local/bin

all:
	@cat Makefile

#$(RACO) exe --gui project.rkt
$(BINARY): project.rkt
	$(RACO) exe project.rkt

build: $(BINARY)

clean:
	\rm -rf ./project.app

help: build
	$(BINARY) --help

install: build
	cp $(BINARY) $(INSTALL_DIR)
	cp $(BINARY) $(INSTALL_DIR)/re
	cp $(BINARY) $(INSTALL_DIR)/pro

install-deps:
	$(RACO) pkg install "git://github.com/adolfopa/racket-mustache.git?path=mustache"

run: build
	$(BINARY)

run-example: build
	$(BINARY) foo bar baz bif

b: build
h: help
i: install
r: run
rx: run-example
