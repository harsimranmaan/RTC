
### main route ###

exports.index = (req, res) -> 
    details={ title: 'Remember the cow',username:"maan",list:["asd","asd"]}
    res.render 'index', details
