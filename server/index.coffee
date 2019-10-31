environment = process.env.NODE_ENV or 'development'

Koa     = require 'koa'
router  = require('koa-router')()
cors    = require '@koa/cors'
Sentry  = require '@sentry/node'
path    = require 'path'

require('dotenv').config path: path.resolve process.cwd(), ".env.#{environment}"
{ PORT, SENTRY_DSN_API, MONGO_URL } = process.env

ridingAt = if MONGO_URL?
  require './mongo'
else
  require './memory'

router.get '/:lat,:lng', (ctx)->
  #ctx.set 'Cache-Control', "public, max-age=#{7*24*60*60}"
  try
    ctx.body = await ridingAt ctx.params.lat, ctx.params.lng
  catch err
    ctx.body = err
    ctx.status = 404

app = new Koa
app.use (ctx, next)->
  start = Date.now()
  await next()
  console.log [
    (new Date()).toISOString().padEnd 28
    "#{Date.now() - start}ms".padEnd 8
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
