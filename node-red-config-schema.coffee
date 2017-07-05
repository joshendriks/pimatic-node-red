# #node-red configuration options
# Declare your config option for your plugin here. 
module.exports = {
  title: "node-red config options"
  type: "object"
  properties:
    port:
      description: "The listener port used for the node-red web application server"
      type: "integer"
      default: 8000
}