FROM cusdeb/alpine3.7-node:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV BOT_NAME "rocketbot"

ENV BOT_OWNER "No owner specified"

ENV BOT_DESC "Hubot with rocketbot adapter"

ENV EXTERNAL_SCRIPTS=hubot-help

ENV RC_HUBOT_VERSION 1.0.11

RUN apk --update add \
    bash \
    curl \
    git \
    sudo \
 && npm install -g \
    coffeescript \
    generator-hubot \
    yo \
 && adduser -D hubot \
 && cd /home/hubot \
 && sudo -u hubot yo hubot --owner="$BOT_OWNER" --name="$BOT_NAME" --description="$BOT_DESC" --defaults \
 && sed -i /heroku/d ./external-scripts.json \
 && sed -i /redis-brain/d ./external-scripts.json \
 && sudo -u hubot npm install hubot-scripts \
 && sudo -u hubot npm install hubot-rocketchat@$RC_HUBOT_VERSION \
 # Cleanup
 && apk del \
    curl \
    sudo \
&& rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /entrypoint.sh

USER hubot

WORKDIR /home/hubot

ENTRYPOINT ["/entrypoint.sh"]

