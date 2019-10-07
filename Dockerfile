FROM node:latest
MAINTAINER Jordan Jethwa

# Environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV HUBOT_SLACK_TOKEN nope-1234-5678-91011-00e4dd
ENV HUBOT_NAME myhubot
ENV HUBOT_OWNER none
ENV HUBOT_DESCRIPTION Hubot
ENV EXTERNAL_SCRIPTS "hubot-help,hubot-pugme"

RUN useradd hubot -m

RUN npm install -g hubot coffeescript yo generator-hubot

USER hubot

WORKDIR /home/hubot

RUN yo hubot --owner="${HUBOT_OWNER}" --name="${HUBOT_NAME}" --description="${HUBOT_DESCRIPTION}" --defaults && sed -i /heroku/d ./external-scripts.json && sed -i /redis-brain/d ./external-scripts.json && npm install hubot-scripts && npm install hubot-slack --save

VOLUME ["/home/hubot/scripts"]

CMD node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
	npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && \
	bin/hubot -n $HUBOT_NAME --adapter slack
