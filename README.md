"# pimatic-node-red" 

Issues
1. Node-red runs in it's own server. I did not manage to get the websocket running on the pimatic server. UI and the engine do work!
2. Upon each deploy "variableManager.on('variableValueChanged', ..." is executed. This results in multiple message for a single change. Depending on the ammount of deploys that were done from node-red UI
