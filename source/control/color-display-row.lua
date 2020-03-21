


-- Registering entity into system
local private = {}
local display = {}
entities["color-display-row"] = display
local letters = {"A","B","C","D","E"}

local cin = defines.circuit_connector_id.combinator_input	
local cout = defines.circuit_connector_id.combinator_output


display.build = function(entity)
	local spawned = {constant}
	
	local constant = private.setupInvisibleConstant(entity)
	table.insert(spawned, constant)
	
	local index = 1
	for i=4,0,-1 do
		local panel = private.setupLampPanel(entity, index)
		local decider = private.setupInvisibleDecider(entity, index)
		local arithmetic = private.setupInvisibleArithmetic(entity, index)
		
		-- connect wires:
		private.connect(entity, decider, true, true, nil, cin)
		private.connect(decider, arithmetic, true, false, cout, cin)
		private.connect(constant, arithmetic, false, true, nil, cin)
		private.connect(arithmetic, panel, true, false, cout, nil)
		
		index = index + 1
		table.insert(spawned, panel)
		table.insert(spawned, decider)
		table.insert(spawned, arithmetic)
	end
	

	return {
		spawned = spawned
	}
end


display.remove = function(data)
	if data.spawned then
		for _,entity in pairs(data.spawned) do
			entity.destroy()
		end
	end
end



private.connect = function(e1, e2, red, green, e1conn, e2conn)
	if red then
		e1.connect_neighbour({wire=defines.wire_type.red, target_entity=e2, 
			source_circuit_id = e1conn, target_circuit_id = e2conn })
	end
	if green then
		e1.connect_neighbour({wire=defines.wire_type.green, target_entity=e2, 
			source_circuit_id = e1conn, target_circuit_id = e2conn })
	end
end


private.setupLampPanel = function(entity, index)
	local panel = entity.surface.create_entity{ 
		name="display-unselectable-panel",
		position = { entity.position.x, entity.position.y + index - 1 },
		force = entity.force
	}
	-- set condition
	local behave = panel.get_or_create_control_behavior()
	behave.use_colors = true
	behave.circuit_condition = { condition = {
			comparator = ">", 
			first_signal = { type="virtual", name="signal-anything" },
			constant=0
		}
	}
	return panel
end


private.setupInvisibleDecider = function(entity, index)
	local combinator = entity.surface.create_entity{ 
		name="invisible-decider-combinator",
		position = { entity.position.x - 1 , entity.position.y + index - 1 },
		force = entity.force,
	}
	local behave = combinator.get_or_create_control_behavior()
	behave.parameters = {
		parameters = {
			first_signal = { type="virtual", name="signal-"..letters[index] },
			second_signal = nil,
			constant = 0,
			comparator = ">",
			output_signal = { type="virtual", name="signal-"..letters[index] },
			copy_count_from_input = true,
		}
	}
	return combinator
end


private.setupInvisibleArithmetic = function(entity, index)
	local combinator = entity.surface.create_entity{ 
		name="invisible-arithmetic-combinator",
		position = { entity.position.x + 1 , entity.position.y + index - 1 },
		force = entity.force,
	}
	local behave = combinator.get_or_create_control_behavior()
	behave.parameters = {
		parameters = {
			first_signal = { type="virtual", name="signal-each" },
			second_signal = { type="virtual", name="signal-"..letters[index] },
			operation = "+",
			output_signal = { type="virtual", name="signal-each" },
		}
	}
	return combinator
end

private.setupInvisibleConstant = function(entity)
	local constant = entity.surface.create_entity{ 
		name="invisible-constant-combinator",
		position = { entity.position.x  , entity.position.y - 1 },
		force = entity.force,
	}
	local behave = constant.get_or_create_control_behavior()
	behave.set_signal(1, {signal = {type="virtual",name="signal-red"}, count = -7})
	behave.set_signal(2, {signal = {type="virtual",name="signal-green"}, count = -6})
	behave.set_signal(3, {signal = {type="virtual",name="signal-blue"}, count = -5})
	behave.set_signal(4, {signal = {type="virtual",name="signal-yellow"}, count = -4})
	behave.set_signal(5, {signal = {type="virtual",name="signal-pink"}, count = -3})
	behave.set_signal(6, {signal = {type="virtual",name="signal-cyan"}, count = -2})
	behave.set_signal(7, {signal = {type="virtual",name="signal-grey"}, count = -1})
	behave.set_signal(8, {signal = {type="virtual",name="signal-black"}, count = 2147483647})
	return constant
end