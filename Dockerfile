FROM keymetrics/pm2:8-alpine

RUN apk --update add tzdata

# SSL
COPY ./files/ssl/ca.crt /etc/ssl/certs/custom/ca.crt
COPY ./files/ssl/cert.crt /etc/ssl/certs/custom/cert.crt
COPY ./files/ssl/priv.key /etc/ssl/certs/custom/priv.key

# Bundle APP files
COPY ./files/src/socket/ src/

COPY app.json .

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install --production

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD [ "pm2-runtime", "start", "app.json" ]
