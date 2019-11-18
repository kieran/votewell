{ MongoClient } = require 'mongodb'

mongo = null

module.exports = ridingAt = (lat, lng)->
  # (re?)connect to mongo
  unless mongo?
    console.log 'Connecting to mongo...'
    { MONGO_URL } = process.env
    mongo = await MongoClient.connect MONGO_URL, useNewUrlParser: true

  new Promise (resolve, reject)->
    return reject('Not Found') unless lat and lng

    doc = await mongo.db().collection('ridings').findOne(
      geometry:
        $geoIntersects:
          $geometry:
            type: "Point"
            coordinates: [ parseFloat(lng), parseFloat(lat) ]
    )

    if riding = doc?.properties?.name
      resolve riding
    else
      reject 'Not Found'
