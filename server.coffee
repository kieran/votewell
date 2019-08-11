Koa     = require 'koa'
router  = require('koa-router')()
cors    = require '@koa/cors'
tag     = require "@turf/tag"
fs      = require 'fs'

geoJson = JSON.parse fs.readFileSync "#{__dirname}/data/ridings.json", 'utf8'

ridingAt = (lat, lng)->
  return null unless lat and lng
  points =
    type: "FeatureCollection"
    features: [
      type: 'Feature'
      geometry:
        type: 'Point'
        coordinates: [lng, lat]
      properties: {}
    ]
  tag(points, geoJson, 'ENNAME', 'riding')?.features[0]?.properties?.riding

router.get '/:lat,:lng', (ctx)->
  ctx.set 'Cache-Control', "public, max-age=#{24*60*60}"
  unless ctx.body = ridingAt ctx.params.lat, ctx.params.lng
    ctx.status = 404
    ctx.body = 'Not Found'

app = new Koa
app.use cors()
app.use router.routes()
app.listen process.env.PORT or 3000
