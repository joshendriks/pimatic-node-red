module.exports = (env) ->
  http = env.require 'http'
  express = env.require 'express';
  RED = require 'node-red'

  class NodeRed extends env.plugins.Plugin

    init: (@app, @framework, @config) =>
      env.logger.info("Hello World")
      settings = {
        httpAdminRoot:"/red",
        httpNodeRoot: "/api",
        userDir:__dirname + "/../../",
        nodesDir:__dirname,
        pimaticFramework:@framework,
        functionGlobalContext: { }
      }
	  
      appie = express();
      appie.use("/",express.static("public"));
      server = http.createServer(appie);
	  
      env.logger.info "RED init"
      RED.init(server,settings)
      appie.use(settings.httpAdminRoot,RED.httpAdmin)
      appie.use(settings.httpNodeRoot,RED.httpNode)
      server.listen(8000);
      
      @framework.on 'server listen', (context)=>
        finished = true
        env.logger.info "RED start"
        RED.start()
        return
  return new NodeRed
  
  