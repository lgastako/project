RACO=raco

BINARY=./project

INSTALL_DIR=~/local/bin

all:
	@cat Makefile

$(BINARY): *.rkt
	$(RACO) exe project.rkt

build: $(BINARY)

clean:
	\rm -rf ./project.app

help: build
	$(BINARY) --help

help2:  # (no args should produce --help output)
	$(BINARY)

install: build
	cp $(BINARY) $(INSTALL_DIR)
	cp $(BINARY) $(INSTALL_DIR)/re
	cp $(BINARY) $(INSTALL_DIR)/pro

install-deps:
	$(RACO) pkg install "git://github.com/adolfopa/racket-mustache.git?path=mustache"

run-hello: build
	$(BINARY) hello

run-hi-user: build
	$(BINARY) hi

run-hi-john: build
	$(BINARY) hi john

b: build
h: help
h2: help2
i: install
rh: run-hello
rhu: run-hi-user
rhj: run-hi-john
