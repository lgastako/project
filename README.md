# project

Yes, this project is named "project."  Good luck searching for it. :)

This project also is nowhere near working.  I'm trying to spec it out via
writing this README as if it were already complete.  Then I'll build to that
spec.

The idea is that any given project has some common commands that need to be run,
so we create a Projectfile or Cmdfile or Projection file or Project.ion or
whatever, and it's basically like a Makefile, Vagrantfile, what have you, but
what it does is dynamically configure the commands that can be run via the
"project" command.

So you can think of project as 'project'ing your shortened/cleaned up commands
from the short version to the full version.

## Benefits / Justification vs Other Tools

- Advantages/Disadvantages vs Not Having It
  - Less typing / thinking / etc
  - Discoverability of core project activities.
  - Projectfile doubles as (always in sync) documentation of the same.

- Advantages/Disadvantages vs Makefiles
  - More reasonable argument handling -- skip recursive make calls with
    environment variables set, etc.

- Advantages/Disadvantages vs shell aliases
  - Auto-generated documentation
  - Stored by project instead of by person

- Advantages/Disadvantages vs Gulp, Grunt, etc.
  - Fast native binary
  - No external dependencies like node, ruby, clojure, etc

## Example

If you commonly run this command:

    $ docker build <container_id> -t -i <prog:/bin/bash>

You could create a Projectfile like so:

    build:
      in: $(CONTAINER_ID) $(PROG:/bin/bash)
      out: docker build $(CONTAINER_ID) -t -i $(PROG)

Which would allow you to run this command:

    $ project build c4b2d4b

And have it translated into this:

    $ docker build c4b2d4b -t -i /bin/bash

Or this command:

    $ project build web runserver

And have it translated into this:

    $ project build web -t -i runserver

You can add multiple sub commands to the same Projectfile, eg.

    build:
      in: $(DIR:.)
      out: docker build $(DIR)

    run:
      in: $(CONTAINER_ID) $(PROG:/bin/bash)
      out: docker run $(CONTAINER_ID) -t -i $(PROG)

    shell:
      in: $(CONTAINER_ID)
      out: project run $(CONTAINER_ID)

    vm:
      in: up
      out: vagrant up

which would allow for

    $ project build           -> $ docker build .
    $ project build foo       -> $ docker build foo
    $ project shell foo       -> $ docker run foo -t -i /bin/bash
    $ project run foo         -> $ docker run foo -t -i /bin/bash
    $ project run foo bar     -> $ docker run foo -t -i bar
    $ project vm up           -> $ vagrant up

etc...

## Chaining Commands

When you use a "project foo ..." command as command in the out list project will

- What about chaining commands? We don't want to get too crazy and reimplement
  all of shell scripting or Makefiles or whatever but there at least have to be
  some common patterns we could support, like maybe just having "out": be an
  array of commands instead of a string, and treating them all as being joined
  by && in shell, etc.  Actually I think that is the one really common case.



## Help generation

The --help output will be generated automatically.  E.g. for the example above,
it would be something like this:

    Project Specific Commands

    Usage:
      project build [<dir>]
      project run <container_id> [<prog>]
      project shell <container_id>
      project vm [up|down]
      project -h | --help
      project --version

    Options:
      -h --help     Show this screen.
      --version     Show version.

## Shortcuts

You can define shortcuts, like "b" for "build" or "r" for run.  Then you can
alias "p" to "project" and end up typing commands like "p b" for "project build"
which gets further expanded, etc.

## blah blah

- You can use extra commands in the config file to override e.g. the "Project Specific Commands" name, etc.
- When you have the output of a command generate a new "project ..." by default the command will
  be optimized and processed internally rather than creating multiple levels of shells, etc.
  You can override this behavior, if for some reason that is necessary, by providing the blah blah
  option in the config file.

## JSON Config Format Strawman

    {
        "commands": {
            "build": {
                "in": "$(DIR:.)",
                "out": "docker build $(DIR)"
            },
            "run": {
                "in": "$(CONTAINER_ID) $(PROG:/bin/bash)",
                "out": "docker run $(CONTAINER_ID) -t -i $(PROG)"
            },
            "shell": {
                "in": "$(CONTAINER_ID)",
                "out": "project run $(CONTAINER_ID)"
            },
            "vm": {
                "in": "up",
                "out": "vagrant up"
            }
        }
    }

## TODO

- Come up with a better name.

  - Context? ctx?
    eg. "ctx build blah" or "c b blah"

  - do
    eg. "do build blah" or "d b blah"

  - pro
    - (short for project, but also like a pro...)

  - boss
    - (kinda in the same vein but probably slightly more searchable? and maybe
       more badass)

  - ject
    - the latter half of "project"

  - j for ject/john

  - re
    - because you're always re-doing the same things, thats why you made them into commands
      - re build
      - re up
      - re compile
      - re css
      - hmmmm
    - how searchable is "re" though? but "re commander" or something... where
      the command is "re" but the name is longer... "re command line steroids"
      or "re-alias" ? think more

  - Something arbitrary like gulp/grunt/etc

- Decide on filename for "Projectfile".

- Decide on format(s) for projectfile.
  - Viable contenders:
    - JSON
    - Custom language (hey we're already in racket...)
      - What would this look like? There's a start above but it needs to be fleshed out.
  - Pros/cons of both approaches.
    - pro JSON: ubuiquitous
    - pro JSON: existing syntax highlighting and other editor support
    - pro custom: custom crafted with love for this exact situation
    - con custom: requires much more thought/effort/dilligence/time/etc to get right
  - Pros/cons of having one format vs supporting JSON and a custom one
    - con of having both
      - upfront dev costs are higher
      - lifetime support costs are higher

