FROM alpine:3.8

RUN apk add --update --no-cache \
  bash \
  npm \
  mongodb \
  mongodb-tools \
  gzip \
  jq \
  make

RUN mkdir -p /data/db

COPY package.json package-lock.json ./
RUN npm i

COPY .env.* ./
COPY server server
COPY elections elections

COPY Makefile ./

RUN make start_mongo seed_mongo stop_mongo

CMD [ "make", "docker_run" ]
