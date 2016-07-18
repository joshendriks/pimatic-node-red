module.exports = function(RED) {
    function VariableChangedNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
        node.variable = config.variable;
		
		function changeListener(changedVar, value) {
			if(changedVar.name == node.variable) {
				var msg = { payload:value}
				node.send(msg);
			}
        }
		
		RED.settings.pimaticFramework.variableManager.on('variableValueChanged', changeListener);
		
		node.on("close", function(done) {
            RED.settings.pimaticFramework.variableManager.removeListener("variableValueChanged", changeListener)
			done();
        });
    }
    RED.nodes.registerType("variable in",VariableChangedNode);

    function DeviceAttributeChangedNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
        node.device = config.device;
        node.action = config.action;
		
		var device = RED.settings.pimaticFramework.deviceManager.getDeviceById(node.device);
		if (device) {
			if (device.hasAction(node.action)) {
				node.status({fill:"green",shape:"ring",text:"ok"});
			} else {
				node.status({fill:"red",shape:"ring",text:"action not found"});
			}
		} else {
			node.status({fill:"red",shape:"ring",text:"device not found"});
		}
		
		node.on('input', function(msg) {
            var device = RED.settings.pimaticFramework.deviceManager.getDeviceById(node.device);
			if (device) {
				device[node.action]();
			} else {
				node.status({fill:"red",shape:"ring",text:"device not found"});
			}
        });
    }
    RED.nodes.registerType("device out",DeviceAttributeChangedNode);
}