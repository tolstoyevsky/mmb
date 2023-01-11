FROM alpine:3.17
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV NOTIFY_PUSH_VER v0.3.0

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.17/community >> /etc/apk/repositories \
 && apk --update add \
    cargo \
    git \
    libgcc \
    rust \
 && cd \
 && git clone -b "${NOTIFY_PUSH_VER}" --depth 1 https://github.com/nextcloud/notify_push.git \
 && cd notify_push \
 && cargo build --release \
 && cp target/release/notify_push /usr/local/bin \
 \
 # Cleanup
 && apk del \
    cargo \
    git \
    rust \
 && rm -r /root/notify_push \
 && rm -r /var/cache/apk/*

COPY ./docker-entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

