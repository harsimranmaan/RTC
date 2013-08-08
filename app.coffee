###
Entry point for execution
###
### Module dependencies required ###
express = require 'express'
routes = require './routes'
user = require './routes/user'
http = require 'http'
path = require 'path' 

app = express()

### For all environments ###
### Get the port from the process environment - HEROKU Configured###
app.set 'port', process.env.PORT || 3000
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser('your secret here')
app.use express.session()
app.use app.router
### less for css ###
app.use require('less-middleware')({ src: __dirname + '/public' })
app.use express.static(path.join(__dirname, 'public')) 

### development only ###

app.use express.errorHandler() if 'development' == app.get('env')


app.get '/', routes.index 
app.get '/users', user.list
### Start the server###
http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'

