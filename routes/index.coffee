
### main route ###

exports.index = (req, res) -> 
    if req.session.username
        name = req.session.username
    else
        name=''
    if name
        list= require('./../'+name+'_list.json').list
    else
        list=[]
    details={ title: 'Remember the cow',username:name,list:list}
    res.render 'index', details
