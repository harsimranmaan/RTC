
### GET users listing. ###
userDb = require './../users.json'
_ = require 'underscore'

exports.list = (req, res) ->
    res.send "respond with a resource"

exports.login = (req, res) ->
    resObj = {}
    req.session.username =''
    if req.body.username and req.body.password
        if checkLogin(req.body.username,req.body.password)
            req.session.username = req.body.username  
    resObj.name= req.session.username
    if resObj.name
        resObj.list= require('./../'+resObj.name+'_list.json').list 
    else
        resObj.list = []
    res.set "Content-Type", "application/json"
    res.send JSON.stringify resObj

exports.logout = (req, res) ->
    req.session.destroy()
    res.send 'loggedOut'

checkLogin= (username,password)->
   user= _.filter(userDb.users, (user)->
        return user if user.user is username
    )
    return true if user and user[0] and  user[0].password is password
    return false
    
    
