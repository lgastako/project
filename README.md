# Projector

Projector is nowhere near working.  I'm trying to spec it out via writing this
README as if it were already complete.  Then I'll build to that spec.

The idea is that any given project has some common commands that need to be run,
so we create a Projector.json file that is like a Makefile or Vagrantfile in
that it sits in the root of your project and contains project specific settings.

In the case of a Projector.json file the settings describe synthetic project
specific command forms.

So you can think of Projector as "projecting" your shortened/cleaned up commands
from the short version to the long version.


## Examples

If you commonly run commands like this:

```bash
    $ docker run <container_id> -t -i <prog>>
```

Where <prog> is almost always /bin/bash but occasionally other commands
(possibly with arguments), then you could create a Project.json like so:

```json
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
```

which would allow you to run this command:

```bash
    $ project run c4b2d4b3
```

and have it translated into this:

```bash
    $ docker run c4b2d4b3 -t -i /bin/bash
```

or this:

```bash
    $ project run 86c19ba9 run-server --port 8080
```

translated into this:

```bash
    $ docker run 86c19ba9 -t -i run-server --port 8080
```

You can add multiple sub commands to the same Projector.json, and a nested
"project.name" key to override the program name in the help out. eg.

```json
    {
        "project": {
            "name": "Self Demo - Project Specific Commands"
        },
        "commands": {
            "build": {
                "in": "[<dir>]",
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
```

which would allow for

```bash
    $ project build           -> $ docker build .
    $ project build foo       -> $ docker build foo
    $ project shell foo       -> $ docker run foo -t -i /bin/bash
    $ project run foo         -> $ docker run foo -t -i /bin/bash
    $ project run foo bar     -> $ docker run foo -t -i bar
    $ project vm up           -> $ vagrant up
```

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

```bash
    $ project b            -> $ project build           -> $ docker build .
    $ project b foo        -> $ project build foo       -> $ docker build foo
    $ project s foo        -> $ project shell foo       -> $ docker run foo -t -i /bin/bash
    $ project r foo        -> $ project run foo         -> $ docker run foo -t -i /bin/bash
    $ project r foo bar    -> $ project run foo bar     -> $ docker run foo -t -i bar
    $ project v u          -> $ project vm up           -> $ vagrant up
```

If you go so far as to create an alias something like this:

```bash
    $ alias p=project
```

Then you end up with something like this:

```bash
    $ p b            -> $ project build           -> $ docker build .
    $ p b foo        -> $ project build foo       -> $ docker build foo
    $ p s foo        -> $ project shell foo       -> $ docker run foo -t -i /bin/bash
    $ p r foo        -> $ project run foo         -> $ docker run foo -t -i /bin/bash
    $ p r foo bar    -> $ project run foo bar     -> $ docker run foo -t -i bar
    $ p v u          -> $ project vm up           -> $ vagrant up
```

## Chaining Commands

When the output of one command is another Project command (i.e. "project ...")
then Projector will follow the chain internally without executing new processes
until it lands on a non "project ..." form.

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
- Actually process buffer instead of 999999 (in cfg.rkt)
- Handle case of no Projector.json
- Allow specifying alternative Projector.json filename.
- Treat empty Projector.json file as "{}" JSON.
- Print a message about the Projector.json file being empty if there are no commands.
