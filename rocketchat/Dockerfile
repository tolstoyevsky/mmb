FROM node:12-bullseye
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV BUNDLE_DIR /home/rocketchat/bundle

# Rocket.Chat Buildmaster <buildmaster@rocket.chat>
ENV PUBLIC_KEY 0E163286C20D07B9787EBE9FD7F9D0414FD08104

ENV RC_VERSION 4.3.0

COPY patches /home/rocketchat/patches

RUN apt-get update \
 && apt-get install -y \
    curl \
    gnupg \
    patch \
 && useradd -m rocketchat \
 # Install Rocket.Chat
 && for i in $(seq 1 10); do \
      gpg --no-tty --keyserver keyserver.ubuntu.com --recv-keys "${PUBLIC_KEY}" && break; \
      rm -r /root/.gnupg; \
    done \
 && cd /home/rocketchat \
 && curl -fSL https://releases.rocket.chat/"${RC_VERSION}"/download -o rocket.chat.tgz \
 && curl -fSL https://releases.rocket.chat/"${RC_VERSION}"/asc -o rocket.chat.tgz.asc \
 && gpg --batch --verify rocket.chat.tgz.asc rocket.chat.tgz \
 && tar zxf rocket.chat.tgz \
 && rm rocket.chat.tgz rocket.chat.tgz.asc \
 && cd "${BUNDLE_DIR}" \
 # Patches apply
 && for path in $(ls ../patches/*.patch 2> /dev/null) \
 ; do patch -p1 < "../patches/${path}" \
 ; done \
 && cd programs/server \
 && npm install \
 && curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
 && chmod +x wait-for-it.sh \
 && mv wait-for-it.sh /usr/local/bin \
 # Cleanup
 && apt-get purge -y \
    curl \
    gnupg \
    patch \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR "${BUNDLE_DIR}"

USER rocketchat

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["docker-entrypoint.sh"]
