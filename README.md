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

If you commonly run commands like this:

    $ docker run <container_id> -t -i <prog>>

Where <prog> is almost always /bin/bash but occasionally other commands
(possibly with arguments), then you could create a Project.json like so:

    {
        "commands": {
            "run": {
                "in": "<container_id> [<prog> <args>...]",
                "defaults": {
                    "<prog>": "/bin/bash"
                },
                "out": "docker run <container_id> -t -i <prog> <args>"
            }
        }
    }

Which would allow you to run this command:

    $ project run c4b2d4b3

And have it translated into this:

    $ docker run c4b2d4b3 -t -i /bin/bash

Or this:

    $ project run 86c19ba9 run-server --port 8080

Translated into this:

    $ docker run 86c19ba9 -t -i run-server --port 8080

You can add multiple sub commands to the same Projectfile, and a nested
"project.name" key to override the program name in the help out. eg.

    {
        "project": {
            "name": "Self Demo - Project Specific Commands"
        },
        "commands": {
            "build": {
                "in": "[--dir=<dir>]",
                "defaults": {
                    "<dir>": "."
                },
                "out": "docker build <dir>"
            },
            "run": {
                "in": "<container_id> [<prog> <args>...]",
                "defaults": {
                    "<prog>": "/bin/bash"
                },
                "out": "docker run <container_id> -t -i <prog> <args>"
            },
            "shell": {
                "in": "<container_id>",
                "out": "project run <container_id>"
            },
            "vm up": {
                "in": "",
                "out": "vagrant up"
            },
            "vm down": {
                "in": "",
                "out": "vagrant down"
            }
        }
    }

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

The --help output will be generated automatically.  Continuing with our example,
in our case it would be something like this:

    Self Demo - Project Specific Commands

    Usage:
      project build [--dir=<dir>]
      project run <container_id> [<prog> <args>...]
      project shell <container_id>
      project vm up
      project vm down
      project -h | --help
      project --version

    Options:
      -h --help     Show this screen.
      --version     Show version.


## Shortcuts

You only need to include as much of the command as is necessary to disambiguate
it, so continuing with our example, the following commands would all be
equivalent:

    $ project b            -> $ project build           -> $ docker build .
    $ project b foo        -> $ project build foo       -> $ docker build foo
    $ project s foo        -> $ project shell foo       -> $ docker run foo -t -i /bin/bash
    $ project r foo        -> $ project run foo         -> $ docker run foo -t -i /bin/bash
    $ project r foo bar    -> $ project run foo bar     -> $ docker run foo -t -i bar
    $ project v u          -> $ project vm up           -> $ vagrant up


## Chaining Commands

When you use a "project foo ..." command as command in the out list project will
recursively evaluate the command until it lands on a non "project... " command.

Cyclic loops in in/out pairs will be detected and will result in an error.


## TODO

- Implement docopt
- Use generated help as input to docopt
- Implement out parsing
- Implement command execution
- Implement default parsing
- Finish help generation
- Implement shortcuts
- Implement chaining
- Implement cyclic loop detection.

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

  - cmd
    - con: clashses with DOS cmd shell
      - could do "cmds" or "cmdz" or something but that doesn't have the same ring
        - maybe "commando" with a hint towards "command do"

  - projector
    - I like this name and it goes with the notion that you're projecting the in
      form of the command into the out form, but the question then becomes what
      should the command be?  It should be short.

      Ideas:
      - p
      - pj
      - pro
      - proj

  - Something arbitrary like gulp/grunt/etc
