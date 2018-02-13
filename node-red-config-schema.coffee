module.exports = {
  title: "node-red config options"
  type: "object"
  properties:
    port:
      description: "The listener port used for the node-red web application server"
      type: "integer"
      default: 8000
    debug:
      description: "debug output"
      type: "boolean"
      default: false
}