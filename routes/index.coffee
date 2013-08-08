
### main route ###

exports.index = (req, res) -> 
  res.render 'index', { title: 'Remember the cow' }
