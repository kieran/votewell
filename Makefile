.ONESHELL:
SHELL = /bin/bash

NODE_ENV ?= development
ELECTION ?= on
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
	mongod --fork --logpath /mongodb.log

stop_mongo:
	mongod --shutdown

seed_mongo:
	mongo --host ${MONGO_URL} --eval "db.ridings.drop()"

	@cat ./elections/uk/ridings.geojson | \
	jq --compact-output '[ .features[] | select(.type == "Feature") | { geometry, properties: { name: .properties.pcon15nm } } ]' | \
	mongoimport --db votewell -c ridings --jsonArray

	@cat ./elections/ca/ridings.geojson | \
	jq --compact-output '[ .features[] | select(.type == "Feature") | { geometry, properties: { name: .properties.ENNAME } } ]' | \
	mongoimport --db votewell -c ridings --jsonArray

	mongo --host ${MONGO_URL} --eval 'db.ridings.createIndex({ geometry: "2dsphere" })'

docker_build:
	docker image build -t votewell:1.0 .

docker_start:
	docker run -it --publish 3000:${PORT} votewell:1.0

# starts mongo as a background process, returning express to the foreground
# needs .ONESHELL directive & bash
docker_run:
	set -m
	node server/index.js &
	mongod --fork --logpath /mongodb.log
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
