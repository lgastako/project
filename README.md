# project

Yes, this project is named "project."  Good luck searching for it. :)

This project also is nowhere near working.  I'm trying to spec it out via
writing this README as if it were already complete.  Then I'll build to that
spec.

The idea is that any given project has some common commands that need to be
run, so we create a Project.json file that is like a Makefile or Vagrantfile,
what have you, in that it sits in the root of your project and contains
project specific settings.

In the case of a Project.json file though, the settings describe synthetic
project-specific commands.

So you can think of project as 'project'ing your shortened/cleaned up commands
from the short version to the full version.


## Examples

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


## Chaining Commands

When you use a "project foo ..." command as command in the out list project will recursively evaluate the command until it lands on a non "project... " command.

Cyclic loops in in/out pairs will be detected and will result in an error.


## JSON Config Format Strawman

    {
        "project ": {
            "name": "My Awesome Project"
        },
        "commands": {
            "hello": {
                "in": "<name>",
                "out": "echo 'Hello <name>.'",
                "defaults ": {
                    "<name>": "user"
                }
            },
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

- Implement in parsing
- Implement out parsing
- Implement command execution
- Implement default parsing
- Finish help generation
- Allow command definitions to either be a map (for a single form of the command)
  or a list of maps (for a command with multiple forms)

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
