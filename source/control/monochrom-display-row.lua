


-- Registering entity into system
local display = {}
entities["monochrom-display-row"] = display






display.build = function(entity)
	local surface = entity.surface
	local pos = entity.position
	local spawned = {}
	local letters = {"E","D","C","B","A"}
	local index = 1
	for i=4,0,-1 do
		local panel = surface.create_entity{ 
			name="display-unselectable-panel",
			position = { pos.x, pos.y + i },
			force = entity.force
		}
		-- connect wires:
		entity.connect_neighbour({wire=defines.wire_type.red, target_entity=panel})
		entity.connect_neighbour({wire=defines.wire_type.green, target_entity=panel})
		-- set condition
		local b = panel.get_or_create_control_behavior()
		b.circuit_condition = { condition = {
				comparator = ">", 
				first_signal = { type="virtual", name="signal-"..letters[index] },
				constant=0
			}
		}
		index = index + 1
		table.insert(spawned, panel)
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