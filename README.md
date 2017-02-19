# pimatic-node-red
Runs node-red on pimatic

### Features
Run the node-red engine embedded in pimatic. This enables the use of node-red flow directly integrated into the pimatic framework. The following nodes are available:

* **_variable in_** listens for changes on the given variable and send a `msg` where `msg.payload` contains the new value of the variable. Use this node to capture changes on devices. They are variables too. Navigate to `/#variables-page` on you pimatic web interface to see them.
* **_allvariables in_** listens for changes on the any variable and send a `msg` where `msg.payload` contains the new value of the variable and `msg.variable` the name of the variable.
* **_device out_** Calls the given action on the given device whenever a `msg` is received. Use this to switch devices on or off for example.
* **_variable out_** Set the value of the specified variable to the value of `msg.payload`.

### Issues

1. Node-red runs in it's own server. I did not manage to get the websocket running on the pimatic server. UI and the engine do work!

