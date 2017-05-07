FROM	debian:jessie

RUN	apt-get update \
	&& apt-get install -y \
		autoconf \
		build-essential \
		curl \
		git \
		libboost-all-dev \
		libdb-dev \
		libdb4.8++ \
		libdb5.3++-dev \
		libevent-dev \
		libminiupnpc-dev \
		libssl-dev \
		libtool \
	&& rm -rf /var/lib/apt/lists/*

ENV	BERKELEY_DB_MAJOR_VERSION 4.8
ENV	BERKELEY_DB_VERSION $BERKELEY_DB_MAJOR_VERSION.30
ENV	BERKELEY_DB_HOME /usr/local/BerkeleyDB.$BERKELEY_DB_MAJOR_VERSION

RUN	curl -SLO http://download.oracle.com/berkeley-db/db-$BERKELEY_DB_VERSION.NC.tar.gz \
	&& tar -xzf db-$BERKELEY_DB_VERSION.NC.tar.gz \
	&& cd db-$BERKELEY_DB_VERSION.NC/build_unix \
	&& ../dist/configure --enable-cxx --disable-shared \
	&& make \
	&& make install \
	&& cd ../../ \
	&& rm -rf db-$BERKELEY_DB_VERSION.NC \
	&& rm db-$BERKELEY_DB_VERSION.NC.tar.gz

RUN	export CPATH="$BERKELEY_DB_HOME/include" \
	&& export LIBRARY_PATH="$BERKELEY_DB_HOME/lib" \
	&& git clone https://github.com/onsightit/solarcoin.git \
	&& cd solarcoin/src \
	&& make -f makefile.unix \
	&& strip solarcoind \
	&& mv solarcoind /usr/local/bin/ \
	&& cd ../.. \
	&& rm -rf solarcoin

RUN	mkdir /solarcoin

VOLUME	/solarcoin
WORKDIR	/solarcoin

COPY docker-entrypoint.sh /

EXPOSE	18181 18188

ENTRYPOINT	["/docker-entrypoint.sh"]
CMD	["/usr/local/bin/solarcoind", "-datadir=/solarcoin", "-rpcport=18181", "-port=18188"]

