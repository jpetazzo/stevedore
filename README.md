# Stevedore: containerize your development environments

Stevedore is a bit like virtualenv, but deals with the entire system,
instead of just the Python environment. With Stevedore, you can create
multiple "environments", switch between them, and destroy them when you
don't need them anymore.

Each environment is a brand new, freshly-installed, shiny-clean distro,
and the only thing shared between your host machine and the environment
is your `$HOME`. You can think of it as a virtual machine where `$HOME`
would be shared with guestfs or a similar device.

Under the hood, it uses the awesome [Docker](http://docker.io/).


## Quick start

To install stevedore, just put the `stevedore` shell script (in this
repository) anywhere in your `$PATH`.

Let's pretend that we want to hack something using a bleeding-edge
version of Python, but we don't want to break our system.

To create a new environment:

    stevedore new python4

It will take some time the first time, because it needs to pull the
base image. However, it will be lightning-fast after that.

    stevedore enter python4

If your default prompt includes the `$HOSTNAME`, you will see that
you are no longer on `my-local-pc` but on `stevedore-python4`.

You are logged with your user account, and in your `$HOME` directory.
But you are in a "clean" environment, with only a handful of essential
packages installed.

You are automatically a "sudoer", meaning that you can do `sudo -i`
to get a root shell, hack away at your `sources.list`, `apt-get install`
some stuff, etc., without touching your host system. Neato.


## Advanced use

The environment is built using a Dockerfile. 

FIXME


## Things you should be aware of

FIXME


## Full list of commands

```bash
$ stevedore help
stevedore - containerize your development environments.
destroy    Destroy an environment. This cannot be undone.
edit       Launch your editor (emacs) to edit and rebuild an environment.
enter      Enter a given environment.
help       Show this help message.
id         Show the container id of an environment.
list       List existing environments.
log        Show build log for an environment.
new        Create a new environment.
```
