module.exports = function(RED) {
    function AllVariableChangesNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
        node.variable = config.variable;

		function changeListener(changedVar, value) {
			var msg = { payload:value, variable: changedVar.name};
			node.send(msg);
        }
		
		RED.settings.pimaticFramework.variableManager.on('variableValueChanged', changeListener);
		
		node.on("close", function(done) {
            RED.settings.pimaticFramework.variableManager.removeListener("variableValueChanged", changeListener)
			done();
        });
    }
    RED.nodes.registerType("allvariables in",AllVariableChangesNode);
	
    function VariableChangedNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
        node.variable = config.variable;
		node.filter = config.filter;
		node.triggerOnly = config.trigger;
		
		if (RED.settings.pimaticFramework.variableManager.isVariableDefined(node.variable)) {
			node.status({fill:"green",shape:"ring",text:"ok"});
		} else {
			node.status({fill:"red",shape:"ring",text:"variable not found"});
		}
		
		function changeListener(changedVar, value) {
			if(changedVar.name == node.variable) {
                var context = node.context();
                if (context.get('value') != value || !node.filter) {
                    context.set('value', value);
				    var msg = { payload:value, variable: node.variable};
				    node.send(msg);
                }
			}
        }

		node.on('input', function(msg) {
			if (RED.settings.pimaticFramework.variableManager.isVariableDefined(node.variable)) {
				var value = RED.settings.pimaticFramework.variableManager.getVariableValue(node.variable);
				msg.payload = value;
				msg.variable = node.variable;
				node.send(msg);
			}
		});
		
		if (!node.triggerOnly) {
		    RED.settings.pimaticFramework.variableManager.on('variableValueChanged', changeListener);
		}
		
		node.on("close", function(done) {
			if (!node.triggerOnly) {
				RED.settings.pimaticFramework.variableManager.removeListener("variableValueChanged", changeListener);
			}
			done();
        });
    }
    RED.nodes.registerType("variable in",VariableChangedNode);

    function DeviceActionNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
        node.device = config.device;
        node.action = config.action;
	    node.parameter = config.parameter;	
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
                                if (msg.parameter) {
                                    device[node.action](msg.parameter);
                                } else if (node.parameter){
				    device[node.action](node.parameter);
                                } else {
                                    device[node.action]();
                                }

			} else {
				node.status({fill:"red",shape:"ring",text:"device not found"});
			}
        });
    }
    RED.nodes.registerType("device out",DeviceActionNode);
	
	function VariableValueNode(config) {
        RED.nodes.createNode(this,config);
        var node = this;
        node.variable = config.variable;
		node.unit = config.unit;
                node.value = config.value;	
		var variable = RED.settings.pimaticFramework.variableManager.isVariableDefined(node.variable);
		if (variable) {
			node.status({fill:"green",shape:"ring",text:"ok"});
		} else {
			node.status({fill:"red",shape:"ring",text:"variable not found"});
		}
		
		node.on('input', function(msg) {
            var variable = RED.settings.pimaticFramework.variableManager.getVariableByName(node.variable);
			if (variable) {
                                var unit = node.unit ? node.unit : variable.unit;
                                var value = node.value ? node.value : msg.payload;
                                RED.settings.pimaticFramework.variableManager.setVariableToValue(node.variable, value, unit);
			} else {
				node.status({fill:"red",shape:"ring",text:"variable not found"});
			}
        });
    }
    RED.nodes.registerType("variable out",VariableValueNode);
}
