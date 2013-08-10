
### main route ###
fs = require 'fs'

exports.index = (req, res) -> 
    if req.session.username
        name = req.session.username
    else
        name=''
    if name
        list= JSON.parse(fs.readFileSync('./'+name+'_list.json')).list
    else
        list=[]
    details={ title: 'Remember the cow',username:name,list:list}
    ### Render the index view ###
    res.render 'index', details
