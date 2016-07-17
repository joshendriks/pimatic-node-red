# #node-red configuration options
# Declare your config option for your plugin here. 
module.exports = {
  title: "node-red config options"
  type: "object"
  properties:
    option1:
      description: "Some option"
      type: "string"
      default: "foo"
}