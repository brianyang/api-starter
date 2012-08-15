    express = require 'express'
    app = express.createServer()
    mongoose = require 'mongoose'
    request = require 'request'

    mongoose.connect process.env.MONGOHQ_URL or 'mongodb://127.0.0.1/sampledb'

    Schema = mongoose.Schema
    ObjectId = Schema.ObjectID

    Hobby = new Schema
        name:
          type: String
          required: true
          trim: true

    Project = new Schema
      first_name:
        type: String
        #required: true
        trim: true
      last_name:
        type: String
        trim: true
      project_title:
        type: String
        required: true
        trim: true
      hobbies: [Hobby]
      shoe_size: Number
      eye_color: String


    Project = mongoose.model 'Project', Project


    app.set 'view engine', 'jade'
    app.set 'views', __dirname + '/views'
    app.use express.static __dirname + '/public'


    getAll = {}
    redirect = {}
    redirect.musicDir = (req,res) ->
      serviceType = 'getMusicDirectory'
      itemId = '633a5c55736572735c625c4d757369635c6e65775c4c696c5f5761796e655f542d5061696e2d542d5761796e652d323031322d415458'
      #itemId = window.location.search.split('=')[1]
      itemId = req.params.itemId
      url = 'http://by.subsonic.org/rest/' + serviceType + '.view?u=brian&p=home&v=1.1.0&c=myapp&f=json&id=' + itemId

      #url = 'http://google.com'
      #res.send 'done'

      request url, (error,response,body) ->
        res.send body if !error && response.statusCode == 200

      # pass artist id to fetch song data
      #
    redirect.musicFolder = (req,res) ->
      serviceType = 'getMusicFolders'
      url = 'http://by.subsonic.org/rest/' + serviceType + '.view?u=brian&p=home&v=1.1.0&c=myapp&f=json'

      request url, (error,response,body) ->
        res.send body if !error && response.statusCode == 200

    redirect.getIndexes = (req,res) ->
      serviceType = 'getIndexes'
      musicFolderId = req.params.musicFolderId
      url = 'http://by.subsonic.org/rest/' + serviceType + '.view?u=brian&p=home&v=1.1.0&c=myapp&f=json&musicFolderId=' + musicFolderId

      request url, (error,response,body) ->
        res.send body if !error && response.statusCode == 200

    redirect.getCoverArt = (req,res) ->
      serviceType = 'getCoverArt'
      itemId = req.params.itemId
      console.log itemId
      #url = 'http://by.subsonic.org/rest/' + serviceType + '.view?u=brian&p=home&v=1.1.0&c=myapp&f=json&id=' + itemId

      url = 'http://by.subsonic.org/rest/getCoverArt.view?u=brian&p=home&v=1.1&c=myapp&f=json&id=633a5c55736572735c625c4d757369635c736f727465642062656174735c44616e63655c39307320436c7562204d6567616d69782d3243442d323031315c636f7665722e6a7067'
      request url, (error,response,body) ->
        #res.send body if !error && response.statusCode == 200
        res.set 'Content-Type', 'image/jpg'
        res.send(body)
        console.log body

    getAll.projects = (req,res) ->
      res.render 'layout.jade', {foo:'bar'}

    app.get '/', (req,res) ->
      Project.find {},(error, data) ->
        res.json data

    app.get '/all', getAll.projects

    app.get '/getMusicDir/:itemId', redirect.musicDir
    app.get '/getMusicFolder', redirect.musicFolder
    app.get '/getIndexes/:musicFolderId', redirect.getIndexes
    app.get '/getCoverArt/:itemId', redirect.getCoverArt

    app.get '/remove/:id', (req,res) ->
      Project.find({ _id: req.params.id }).remove()
      res.send 'done'

    app.get '/show/:id', (req,res) ->
      Project.findOne { _id: req.params.id },(error, doc) ->
        res.json doc


    app.get '/addproject/:project_title', (req, res) ->
      project_data =
        project_title: req.params.project_title

      person = new Project(project_data)
      person.save (error, data) ->
        if(error)
          res.json error
        else
          res.json data


    app.listen(process.env.PORT || 3001)

