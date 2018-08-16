FROM cusdeb/alpine3.7-node:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV BOT_NAME "rocketbot"

ENV BOT_OWNER "No owner specified"

ENV BOT_DESC "Hubot with rocketbot adapter"

ENV HUBOT_VERSION 2.19.0

ENV RC_HUBOT_BRANCH 930d085472bb9afa122721fa1b0bec59a783b86b

RUN apk --update add \
    bash \
    curl \
    git \
    openntpd \
    sudo \
    tzdata \
 && npm install -g \
    coffeescript \
    generator-hubot \
    yo \
 && adduser -D hubot \
 && cd /home/hubot \
 && sudo -u hubot yo hubot --owner="$BOT_OWNER" --name="$BOT_NAME" --description="$BOT_DESC" --defaults \
 && sed -i /heroku/d ./external-scripts.json \
 && sed -i /redis-brain/d ./external-scripts.json \
 && sudo -u hubot npm install hubot@$HUBOT_VERSION \
 && sudo -u hubot npm install git+https://git@github.com/RocketChat/hubot-rocketchat.git#$RC_HUBOT_BRANCH \
 # Cleanup
 && apk del \
    curl \
    sudo \
&& rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /entrypoint.sh

USER hubot

WORKDIR /home/hubot

ENTRYPOINT ["/entrypoint.sh"]

