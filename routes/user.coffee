
### GET users listing. ###


exports.list = (req, res) ->
  res.send "respond with a resource"

exports.login = (req, res) ->
  res.send '{ "name": '+req.body.username+', "list": ["asdsa","asdas"]}'
