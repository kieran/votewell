environment = process.env.NODE_ENV or 'development'

Koa     = require 'koa'
router  = require('koa-router')()
cors    = require '@koa/cors'
tag     = require "@turf/tag"
fs      = require 'fs'
Sentry  = require '@sentry/node'
path    = require 'path'

require('dotenv').config path: path.resolve process.cwd(), ".env.#{environment}"
{ PORT, SENTRY_DSN_API } = process.env

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
app.use (ctx, next)->
  await next()
  console.log [
    ctx.status.toString().padEnd 6
    ctx.method.padEnd 6
    ctx.url.padEnd 18
    ctx.body
  ].join ' '
app.use cors()
app.use router.routes()

if dsn = SENTRY_DSN_API
  Sentry.init { dsn, environment }
  app.on 'error', (err, ctx)->
    Sentry.withScope (scope)->
      scope.addEventProcessor (event)-> Sentry.Handlers.parseRequest event, ctx.request
      Sentry.captureException err

app.listen PORT or 3000
