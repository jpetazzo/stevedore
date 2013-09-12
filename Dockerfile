FROM ubuntu
RUN apt-get -q update
RUN apt-get -qy install sudo vim emacs python ruby
