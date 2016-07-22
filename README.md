# pimatic-node-red
Runs node-red on pimatic

### Features
Run the node-red engine embedded in pimatic. This enables the use of node-red flow directly integrated into the pimatic framework. The following nodes are available:

* **_variable in_** listens for changes on the given variable and send a `msg` where `msg.payload` contains the new value of the variable. Use this node to capture changes on devices. They are variables too. Navigate to `/#variables-page` on you pimatic web interface to see them.
* **_device out_** Calls the given action on the given device whenever a `msg` is received. Use thid to switch devices on or off for example.

### Issues

1. Node-red runs in it's own server. I did not manage to get the websocket running on the pimatic server. UI and the engine do work!
2. Node **_device out_** cannot yet execute actions that require a parameter.

