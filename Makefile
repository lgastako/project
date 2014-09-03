RACO=raco

all:
	@cat Makefile

exe:
	$(RACO) exe --gui project.rkt
