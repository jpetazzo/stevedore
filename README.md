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


## Let me sing you the song of my Dockerfile

The environment is built using a Dockerfile. If you are familiar with
Dockerfiles, you can edit it with `stevedore edit`. This will start your
favorite editor (actually, `$VISUAL`), and after editing the file, it
will rebuild the environment and restart it. The default Dockerfile
contains some example of commands that you can insert to get you started.

You can also `stevedore rebuild` to rebuild the environment without
going through the editor.

**WARNING:** when you use `stevedore edit` or `stevedore rebuild`,
it will reset the environment to the file described by the Dockerfile!
All customizations (basically, things that you did as root, or outside
of your `$HOME`) will be lost! This is not a bug, this is a feature.
(Really.)

To unclutter the output a bit, Stevedore only display build steps,
not the output of the build step themselves. If you want to see the
full output of a build, you can use `stevedore log`.


## Automatic sudo history

Stevedore replaces `sudo` with a tiny wrapper which will log each execution
of `sudo`. You can see the log file by running `stevedore sudohist`.

This is very helpful to keep track of the commands which potentially
altered your development environment, and are therefore good candidates
for inclusion into the Dockerfile in a `RUN` statement.

For instance, if you entered environment `python4`, and did `sudo pip
install django`, then `sudo apt-get install libxml2`, you can review
those commands with `stevedore sudohist python4`, which will show:

```
pip install django
apt-get install libxml2
```

The sudo history is cleared each time the environment is rebuilt.


## A word about the network sandboxing

Each environment runs in its own sandboxed network space. This means
that if you start a webserver on port 8000 in an environment, you
won't be able to access it through http://localhost:8000/; you have
to find out the IP address of the environment.

To make this as painless as possible, you can use `stevedore url [port]`.
Without a port, it will display an URL with the form http://172.17.1.55/
pointing to your environment. If you specify a port, it will be added
to the URL as a convenience. If that port is also exposed by the
environment (because you added an `EXPOSE` directive to the Dockerfile),
then Stevedore will resolve the port mapped by Docker, and show you
and URL with the form http://localhost:49876/. If you change `localhost`
with your IP address or hostname, it gives an address usable by others
to reach your environment.


## Full list of commands

```bash
$ stevedore
stevedore - containerize your development environments.
destroy    Destroy an environment. This cannot be undone.
edit       Launch your editor (emacs) to edit and rebuild an environment.
enter      Enter a given environment.
help       Show this help message.
id         Show the container id of an environment.
list       List existing environments.
log        Show build log for an environment.
new        Create a new environment.
rebuild    Restore an environment to the state defined by its Dockerfile.
sudohist   Show history of commands that have been started with sudo.
url        Generate an URL pointing to an environment. Port is optional.
```