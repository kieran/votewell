fs      = require 'fs'
tag     = require "@turf/tag"

{ ELECTION } = process.env

geoJson = JSON.parse fs.readFileSync "#{__dirname}/../election/ridings-sm.geojson", 'utf8'

module.exports = ridingAt = (lat, lng)->
  new Promise (resolve, reject)->
    return reject('Not Found') unless lat and lng

    points =
      type: "FeatureCollection"
      features: [
        type: 'Feature'
        geometry:
          type: 'Point'
          coordinates: [lng, lat]
        properties: {}
      ]

    riding = (switch ELECTION
      when 'ca' then tag points, geoJson, 'ENNAME',   'riding'
      when 'uk' then tag points, geoJson, 'pcon15nm', 'riding'
    )?.features[0]?.properties?.riding

    if riding
      resolve riding
    else
      reject 'Not Found'
