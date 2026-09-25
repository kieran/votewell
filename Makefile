.ONESHELL:
SHELL = /bin/bash

NODE_ENV ?= development
ELECTION ?= bc-2026
PORT ?= 3000

include .env.${NODE_ENV}

.PHONY: nvm install election/ clean run dist update_polls start_mongo stop_mongo seed_mongo docker_run

node_modules/:
	@npm i

election/:
	@rm -f ./election && ln -s ./elections/${ELECTION} ./election

install: node_modules/ election/

clean:
	@rm -rf ./node_modules

run: install
	set -m
	npm run serve &
	npm run api
	fg %1

api: install
	@node server/index.js

dist: install
	@npm run dist

update_polls: install
	@npm run update_polls

#
# Docker stuff
#
start_mongo:
	mongod --dbpath /data/db --fork --logpath /mongodb.log

stop_mongo:
	# shutdownServer severs its own connection, so mongosh always exits non-zero
	mongosh "${MONGO_URL}" --quiet --eval 'db.getSiblingDB("admin").shutdownServer()' || true

seed_mongo:
	mongosh "${MONGO_URL}" --quiet --eval 'db.ridings.drop()'

	# property names differ by shapefile
	@cat ./elections/${ELECTION}/ridings.geojson | \
	jq --compact-output '[ .features[] | select(.type == "Feature") | { geometry, properties: { name: (.properties.ED_NAME // .properties.ED_NAMEE), nom: .properties.ED_NAMEF } } ]' | \
	mongoimport --db votewell -c ridings --jsonArray

	mongosh "${MONGO_URL}" --quiet --eval 'db.ridings.createIndex({ geometry: "2dsphere" })'

docker_build:
	docker image build -t votewell:1.0 .

docker_start:
	docker run -it --publish 3000:${PORT} votewell:1.0

# starts mongo as a background process, returning express to the foreground
# needs .ONESHELL directive & bash
docker_run:
	set -m
	node server/index.js &
	mongod --dbpath /data/db --fork --logpath /mongodb.log
	fg %1


#
# GCP Deploy (Google Cloud Run)
#
# build & deploy to google cloud run
# - https://api-xbhormaofa-ue.a.run.app
#
gcloud_build:
	gcloud builds submit --tag gcr.io/votewell/api

gcloud_deploy:
	gcloud run deploy --image gcr.io/votewell/api --platform managed
