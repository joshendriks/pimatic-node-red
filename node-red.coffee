module.exports = (env) ->
  http = env.require 'http'
  express = env.require 'express';
  RED = require 'node-red'

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

      RED.init(server,settings)
      appie.use(settings.httpAdminRoot,RED.httpAdmin)
      appie.use(settings.httpNodeRoot,RED.httpNode)
      server.listen(@config.port);

      @framework.on 'server listen', (context)=>
        finished = true
        RED.start().catch (error) =>
          env.logger.error "Startup failed: ", error
        return
      
      @framework.on "after init", =>
        mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
        if mobileFrontend?
          mobileFrontend.registerAssetFile 'js', "pimatic-node-red/app/link.coffee"
          mobileFrontend.registerAssetFile 'html', "pimatic-node-red/app/link.jade"
          mobileFrontend.registerAssetFile 'css', "pimatic-node-red/app/link.css"
        else
          env.logger.warn "node-red could not find mobile-frontend. Didn't add link."
          
      app.get('/nodered/get', (req, res) =>
        @url = "http://127.0.0.1/" + settings.httpAdminRoot + ":" + @config.port
        res.send(@url)
      )

      @framework.once 'destroy', (context) =>
        context.waitForIt RED.stop()

  return new NodeRed
  
  
