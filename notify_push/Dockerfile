FROM alpine:3.17
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV NOTIFY_PUSH_VER v1.2.2

# Install the push server from the prebuilt release binary (musl target, so it
# runs on Alpine's musl libc). Its version must match the bundled notify_push
# app, and building from source no longer compiles on the cargo Alpine ships.
RUN apk --update add \
    curl \
 && curl -fL -o /usr/local/bin/notify_push \
    "https://github.com/nextcloud/notify_push/releases/download/${NOTIFY_PUSH_VER}/notify_push-x86_64-unknown-linux-musl" \
 && chmod +x /usr/local/bin/notify_push \
 \
 # Cleanup
 && apk del \
    curl \
 && rm -r /var/cache/apk/*

COPY ./docker-entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

