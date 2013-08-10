
### GET users listing. ###
userDb = require './../users.json'
_ = require 'underscore'
fs = require 'fs'

### Handle login ###
exports.login = (req, res) ->
    resObj = {}
    req.session.username =''
    if req.body.username and req.body.password
        if checkLogin(req.body.username,req.body.password)
            req.session.username = req.body.username  
    resObj.name= req.session.username
    if resObj.name
        resObj.list= JSON.parse(fs.readFileSync('./'+resObj.name+'_list.json')).list 
    else
        resObj.list = []
    ### Send the response ###
    res.set "Content-Type", "application/json"
    res.send JSON.stringify resObj

#### Handle logout ###
exports.logout = (req, res) ->
    req.session.destroy()
    res.send 'loggedOut'
### Handle update of list ###
exports.update = (req, res) ->
    resObj = {}
    resObj.name =''
    resObj.list =[]
    if req.session.username
        resObj.name = req.session.username
        if req.body.list
            writeObj = {}
            writeObj.list = JSON.parse(req.body.list)
            resObj.list = writeObj.list if fs.writeFileSync './'+resObj.name+'_list.json',JSON.stringify(writeObj)
    res.set "Content-Type", "application/json"
    res.send JSON.stringify resObj
### Check if a username and pwd is valid ###
checkLogin= (username,password)->
   user= _.filter(userDb.users, (user)->
        return user if user.user is username
    )
    return true if user and user[0] and  user[0].password is password
    return false
    
    
