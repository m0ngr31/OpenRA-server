FROM mono:6.12.0-slim

ARG OPENRA_VERSION
ENV OPENRA_VERSION $OPENRA_VERSION

# https://www.openra.net/download/
ENV OPENRA_RELEASE=https://github.com/OpenRA/OpenRA/releases/download/$OPENRA_VERSION/OpenRA-$OPENRA_VERSION-source.tar.bz2

RUN set -xe

RUN \
  apt-get update; \
  apt-get -y upgrade; \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  bzip2 \
  mono-complete \
  liblua5.1 \
  libsdl2-2.0-0 \
  libopenal1 \
  make \
  patch \
  unzip \
  xdg-utils \
  zenity \
  msbuild \
  wget

RUN useradd -d /home/openra -m -s /sbin/nologin openra

RUN mkdir /home/openra/source; \
  cd /home/openra/source; \
  curl -L $OPENRA_RELEASE | tar xj; \
  make all RUNTIME=mono

# Hack
# "make install" seems not to work anymore, needs debugging
RUN mkdir -p /home/openra/lib/openra; \
  mv /home/openra/source/* /home/openra/lib/openra; \
  # /Hack
  mkdir /home/openra/.openra \
  /home/openra/.openra/Logs \
  /home/openra/.openra/maps

RUN chown -R openra:openra /home/openra/.openra

RUN apt-get purge -y curl make patch unzip; \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
  apt autoremove

EXPOSE 1234

USER openra

WORKDIR /home/openra/lib/openra
VOLUME ["/home/openra/.openra"]

# https://github.com/OpenRA/OpenRA/blob/release-20200202/launch-dedicated.sh
# NOTE: With 2020202 geoip mapping and player IPs are not resolved/disclosed
#       anymore due to upstream and privacy reasons.
#       see options "Server.ShareAnonymizedIPs" and "Server.GeoIPDatabase"

CMD [ "/home/openra/lib/openra/launch-dedicated.sh" ]

# annotation labels according to
# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.title="OpenRA dedicated server"
LABEL org.opencontainers.image.description="Image to run a server instance for OpenRA"
LABEL org.opencontainers.image.url="https://github.com/m0ngr31/OpenRA-server"
LABEL org.opencontainers.image.documentation="https://github.com/m0ngr31/OpenRA-server#readme"
LABEL org.opencontainers.image.version=${OPENRA_VERSION}
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.authors="Joe Ipson"