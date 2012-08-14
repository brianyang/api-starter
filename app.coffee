    express = require 'express'
    app = express.createServer()
    mongoose = require 'mongoose'

    mongoose.connect 'mongodb://127.0.0.1/sampledb'

    Schema = mongoose.Schema
    ObjectId = Schema.ObjectID

    Hobby = new Schema
        name:
          type: String
          required: true
          trim: true

    Person = new Schema
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


    Person = mongoose.model 'Person', Person

    app.get '/', (req,res) ->
      Person.find {},(error, data) ->
        res.json(data)


    app.get '/remove/:id', (req,res) ->
      Person.find({ _id: req.params.id }).remove()
      res.send('done')

      #Person.findOne { username: req.params.username },(error, person) ->
        #res.json(person)
        #res.remove()


    app.get '/addproject/:project_title', (req, res) ->
      project_data =
        project_title: req.params.project_title

      person = new Person(project_data)
      person.save (error, data) ->
        if(error)
          res.json(error)
        else
          res.json(data)


    #app.get '/adduser/:first/:last/:project_title', (req, res) ->
      #person_data =
        #first_name: req.params.first
        #last_name: req.params.last
        #project_title: req.params.project_title

      #person = new Person(person_data)
      #person.save (error, data) ->
        #if(error)
          #res.json(error)
        #else
          #res.json(data)






          ###
    app.get('/addhobby/:username/:hobby', (req, res) -> {
      Person.findOne{ username: req.params.username }, (error, person) ->
            if(error){
                res.json(error)
            }
            else if(person == null){
                res.json('no such user!')
            }
            else{
                person.hobbies.push({ name: req.params.hobby })
                person.save( (error, data) -> {
                    if(error){
                        res.json(error)
                    }
                    else{
                        res.json(data)
                    }
                })
            }

    })
    ###

    app.listen(3001)
    console.log("listening on port %d", app.address().port)

