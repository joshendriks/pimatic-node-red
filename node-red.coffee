module.exports = (env) ->
  http = env.require 'http'
  express = env.require 'express'
  RED = require 'node-red'
  bcrypt = require 'bcryptjs'

  class NodeRed extends env.plugins.Plugin

    init: (@app, @framework, @config) =>
      debug = @config.debug

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
      	if debug
      		env.logger.debug "Authentication is enabled"

        settings.adminAuth = {
          type: "credentials",
          users: []
        }

        if debug
          env.logger.debug "@framework.config.users"
          env.logger.debug @framework.config.users

        newUser = {}
        for user in @framework.config.users
          newUser.username = user.username
          if user.role is 'admin'
            newUser.permissions = "*"
          else
            newUser.permissions = "read"
          newUser.password = bcrypt.hashSync(user.password, 8)         

          settings.adminAuth.users.push(newUser)
          newUser = {}

        if debug
          env.logger.debug "settings.adminAuth.users"
          env.logger.debug settings.adminAuth.users

        RED.init(server,settings)
        appie.use(settings.httpAdminRoot,RED.httpAdmin)
        appie.use(settings.httpNodeRoot,RED.httpNode)
        server.listen(@config.port)
      else
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