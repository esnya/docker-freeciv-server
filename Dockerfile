FROM ubuntu
MAINTAINER ukatama <dev.ukatama@gmail.com>

RUN apt update -yq

RUN apt install -yq wget
RUN wget -q -O /tmp/freeciv.tar.bz2 "http://download.gna.org/freeciv/stable/freeciv-2.5.4.tar.bz2"
RUN apt remove -yq wget

WORKDIR /usr/src/

RUN apt install -yq bzip2
RUN tar xvjf /tmp/freeciv.tar.bz2 && rm -f /tmp/freeciv.tar.bz2
RUN apt remove -yq bzip2
WORKDIR /usr/src/freeciv-2.5.4/

RUN apt-get build-dep -yq freeciv
RUN apt-get install -yq libmysqlclient-dev

ENV CONF "--enable-client=stub --enable-fcdb=all"
RUN ./autogen.sh $CONF
RUN ./configure $CONF

RUN autoconf
RUN make -j
RUN make install

RUN apt install -yq language-pack-ja
RUN apt autoremove -yq

WORKDIR /freeciv
USER 998

RUN freeciv-server --version

EXPOSE 5556
ENTRYPOINT ["freeciv-server"]

