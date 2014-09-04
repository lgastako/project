# project

Yes, this project is named "project."  Good luck searching for it. :)

The idea is that any given project has some common commands that need to be run,
so we create a Projectfile or Cmdfile or Projection file or Project.ion or
whatever, and it's basically like a Makefile, Vagrantfile, what have you, but
what it does is dynamically configure the commands that can be run via the
"project" command."

So you can think of project as projecting your shortened/cleaned up commands
from the short version to the full version.

## Benefits / Justification

- Less typing / thinking / etc
- Projectfile doubles as (always in sync) documentation of common project
  activities.

## Open Questions

- What about chaining commands? We don't want to get too crazy and reimplement
  all of shell scripting or Makefiles or whatever but there at least have to be
  some common patterns we could support, like maybe just having "out": be an
  array of commands instead of a string, and treating them all as being joined
  by && in shell, etc.  Actually I think that is the one really common case.

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

## TODO: Come up with a better name.

- Context? ctx?
  eg. "ctx build blah" or "c b blah"

- do
  eg. "do build blah" or "d b blah"

- Something arbitrary like gulp/grunt/etc
