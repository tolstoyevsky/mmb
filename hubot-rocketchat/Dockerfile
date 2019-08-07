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
    tzdata \
 && npm install -g \
    coffeescript \
    generator-hubot \
    yo \
 && mkdir /root/hubot \
 && cd /root/hubot \ 
 && mkdir -p /root/.config/insight-nodejs \
 && mkdir -p /root/.npm/_cacache \
 && chmod g+rwx /root /root/.config /root/.config/insight-nodejs /bin /root/hubot /root/.npm /root/.npm/_cacache \
 && yo hubot --owner="$BOT_OWNER" --name="$BOT_NAME" --description="$BOT_DESC" --defaults \
 && sed -i /heroku/d ./external-scripts.json \
 && sed -i /redis-brain/d ./external-scripts.json \
 && npm install hubot@$HUBOT_VERSION \
 && npm install git+https://git@github.com/RocketChat/hubot-rocketchat.git#$RC_HUBOT_BRANCH \
 # Cleanup
 && apk del \
&& rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /entrypoint.sh

USER root

WORKDIR /root/hubot

ENTRYPOINT ["/entrypoint.sh"]

