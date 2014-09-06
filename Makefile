RACO=raco

APP=project

BINARY=./$(APP)

INSTALL_DIR=~/local/bin

all:
	@cat Makefile

$(BINARY): *.rkt
	$(RACO) exe $(APP).rkt

build: $(BINARY)

clean:
	\rm -rf $(BINARY)

help: build
	$(BINARY) --help

help2:  # (no args should produce --help output)
	$(BINARY)

install: build
	cp $(BINARY) $(INSTALL_DIR)

install-deps:
	$(RACO) pkg install "git://github.com/adolfopa/racket-mustache.git?path=mustache"

run-b1: build
	$(BINARY) build

run-b2: build
	$(BINARY) build foo/bar/baz


b: build
h: help
h2: help2
i: install
rb1: run-b1
rb2: run-b2
