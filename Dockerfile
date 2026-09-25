FROM node:20-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg \
  gzip \
  jq \
  make \
&& install -d /usr/share/keyrings \
&& curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc \
  | gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg \
&& echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" \
  > /etc/apt/sources.list.d/mongodb-org-8.0.list \
&& apt-get update && apt-get install -y --no-install-recommends \
  mongodb-database-tools \
  mongodb-mongosh \
  mongodb-org-server \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/db

COPY package.json package-lock.json ./
RUN npm i --omit=dev

COPY .env.* ./
COPY server server
COPY elections elections

COPY Makefile ./

RUN make start_mongo seed_mongo stop_mongo

CMD [ "make", "docker_run" ]
