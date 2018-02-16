module.exports = (env) ->
  http = env.require 'http'
  express = env.require 'express';
  RED = require 'node-red'
  brypt = require 'bcryptjs-then'

  class NodeRed extends env.plugins.Plugin

    init: (@app, @framework, @config) =>
      settings = {
        httpAdminRoot:"/red",
        httpNodeRoot: "/api/",
        userDir:__dirname + "/../../",
        nodesDir:[__dirname,__dirname + "/../../"],
        pimaticFramework:@framework,
        functionGlobalContext: { }
      }

      appie = express();
      appie.use("/",express.static("public"));
      server = http.createServer(appie);

      if @config.auth is true
        settings.adminAuth = {
          type: "credentials",
          users: [{
            username: "root",
            password: "$2a$08$zZWtXTja0fB1pzD4sHCMyOCMYz2Z6dNbM6tl8sJogENOMcxWV9DN.",
            permissions: "*"
          }]
        }

        #console.log @framework.config.users
        ###
        [ { username: 'admin', password: 'admin', role: 'admin' },
        { username: 'display', password: 'display', role: 'readonly' } ]
        ###
        newUser = {}
        for user, i in @framework.config.users
          #console.log user.username  #admin \n display
          #console.log user.password  #admin \n display
          #console.log user.role      #admin \n read
          #console.log i              #0 \n 1
         
          newUser.username = user.username
          if user.role is 'admin'
            newUser.permissions = "*"
          else
            newUser.permissions = "read"

          settings.adminAuth.users.push(newUser)

          brypt.hash(user.password, 8).then( (hashed) =>
            #console.log user.username     #display \n display
            #console.log hashed            #$2a$08$EZ4geLNwO3WXc/foQ5b/Ou5FKwcdnv/GApIn3EGd2Am1fatOnjU5a \n $2a$08$SHaUO2Z2Ber1FFSQywWzOOue3nFrgfEZ.cxfL81Hb0zGCDJ5F0TT.

            ###
            if user.role is 'admin'
              console.log {username: "#{user.username}", password: "#{hashed}", permissions: "*"}
              settings.adminAuth.users.push({username: "#{user.username}", password: "#{hashed}", permissions: "*"})
            else
              console.log {username: "#{user.username}", password: "#{hashed}", permissions: "read"}
              settings.adminAuth.users.push({username: "#{user.username}", password: "#{hashed}", permissions: "read"})
            ###
            settings.adminAuth.users[i].password = hashed
         
            #console.log newUser
            ###
            { username: 'admin', permissions: '*' }
            { username: 'display', permissions: 'read' }
            ###
            #settings.adminAuth.users.push(newUser)                      
          )
          newUser = {}
        console.log settings.adminAuth.users
        ###
        [ { username: 'root',
          password: '$2a$08$zZWtXTja0fB1pzD4sHCMyOCMYz2Z6dNbM6tl8sJogENOMcxWV9DN.',
          permissions: '*' },
        { username: 'admin', permissions: '*' },
        { username: 'display', permissions: 'read' } ]
        ###

      RED.init(server,settings)
      appie.use(settings.httpAdminRoot,RED.httpAdmin)
      appie.use(settings.httpNodeRoot,RED.httpNode)
      server.listen(@config.port)

      @framework.on 'server listen', (context)=>
        finished = true
        RED.start().catch (error) =>
          env.logger.error "Startup failed: ", error
        return

      @framework.once 'destroy', (context) =>
        context.waitForIt RED.stop()

  return new NodeRed