module.exports = function(RED) {
    function VariableChangedNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
		node.name = config.name;
        node.variable = config.variable;
		
		RED.settings.pimaticFramework.variableManager.on('variableValueChanged', function(changedVar, value) {
			var msg = { payload:value + changedVar.name}
			node.send(msg);
        });
		
		node.on("close", function(done) {
            if (this.serialConfig) {
                serialPool.close(this.serialConfig.serialport,done);
            } else {
                done();
            }
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