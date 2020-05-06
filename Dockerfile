FROM alpine:3.11 as build

ENV NOMINATIM_VERSION 3.4.2

WORKDIR /opt

RUN set -x && \
    apk add --update --no-cache boost-dev build-base bzip2-dev cmake curl expat-dev gettext-dev git libintl libxml2-dev musl-dev php7 postgresql-dev proj-dev zlib-dev && \
    rm -rf /var/cache/apk/* && \
    git clone https://gitlab.com/rilian-la-te/musl-locales && \
	cd musl-locales && cmake -DLOCALE_PROFILE=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install && \
	cd .. && rm -r musl-locales && \
    curl -s -L http://www.nominatim.org/release/Nominatim-$NOMINATIM_VERSION.tar.bz2 -o nominatim.tar.bz2 && \
    tar -xf nominatim.tar.bz2 && \
    rm -rf nominatim.tar.bz2 && \
    mv Nominatim-$NOMINATIM_VERSION nominatim && \
    cd nominatim && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    rm -rf osm2pgsql/src/ && \
    cd /opt/nominatim && \
    rm -rf .git* .travis.yml *.md *agrant* ChangeLog osm2pgsql

FROM alpine:3.11

ENV LANG=en_US.UTF-8 \
    PGDATA=/var/lib/postgresql/data \
    NOMINATIM_HOME=/opt/nominatim

RUN set -x && \
    apk update && apk upgrade && \
    apk add --no-cache boost ca-certificates curl libintl nginx openjdk11-jre-headless openssl php7 php7-fpm php7-intl php7-json php7-opcache php7-openssl php7-pdo_pgsql php7-pear php7-pgsql postgis postgresql postgresql-contrib sudo supervisor tzdata && \
    rm -rf /var/cache/apk/* && \
    rm /etc/nginx/conf.d/default.conf && \
    mkdir /opt/osmosis && \
    curl -Ls https://github.com/openstreetmap/osmosis/releases/download/0.48.0/osmosis-0.48.0.tgz -o /opt/osmosis/osmosis.tar.gz && \
    cd /opt/osmosis && tar -zxf osmosis.tar.gz && \
    rm -rf osmosis.tar.gz && \
    cd / && ln -s /opt/osmosis/bin/osmosis /usr/bin/osmosis && \
    mkdir /etc/nginx/ssl /opt/conf && \
    echo "Set disable_coredump false" >> /etc/sudo.conf && \
    mkdir -p /run/postgresql $PGDATA && \
    chown -R postgres:postgres /run/postgresql $PGDATA

COPY --from=claflico/alpine-osmium:1.11.1 \
     /usr/local/bin/osmium \
     /usr/bin/

WORKDIR /opt

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/*.conf /opt/conf/
COPY docker-entrypoint.sh .
COPY update-pbf-data.sh .
COPY variables.sh .
COPY --from=build /usr/bin/locale /usr/bin/locale
COPY --from=build /usr/share/locale /usr/share/locale
COPY --from=build /usr/share/i18n /usr/share/i18n
COPY --from=build /opt/nominatim $NOMINATIM_HOME

EXPOSE 80
EXPOSE 443

VOLUME /var/lib/postgresql/data
VOLUME /opt/nominatim/data

CMD ["/opt/docker-entrypoint.sh"]
