module.exports = function(RED) {
    function VariableChangedNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
        node.variable = config.variable;
		
		if (RED.settings.pimaticFramework.variableManager.isVariableDefined(node.variable)) {
			node.status({fill:"green",shape:"ring",text:"ok"});
		} else {
			node.status({fill:"red",shape:"ring",text:"variable not found"});
		}
		
		function changeListener(changedVar, value) {
			if(changedVar.name == node.variable) {
				var msg = { payload:value, variable: node.variable};
				node.send(msg);
			}
        }

		node.on('input', function(msg) {
			if (RED.settings.pimaticFramework.variableManager.isVariableDefined(node.variable)) {
				var value = RED.settings.pimaticFramework.variableManager.getVariableValue(node.variable);
				var msg = { payload:value, variable: node.variable};
				node.send(msg);
			}
		});
		
		RED.settings.pimaticFramework.variableManager.on('variableValueChanged', changeListener);
		
		node.on("close", function(done) {
            RED.settings.pimaticFramework.variableManager.removeListener("variableValueChanged", changeListener)
			done();
        });
    }
    RED.nodes.registerType("variable in",VariableChangedNode);

    function DeviceActionNode(config) {
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
    RED.nodes.registerType("device out",DeviceActionNode);
}