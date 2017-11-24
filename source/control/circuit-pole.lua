require "libs.itemSelection.control"

-- Registering entity into system
local circuitPole = {}
entities["circuit-pole"] = circuitPole

-- Constants
local m = {} --used for methods of the circuitPole

function circuitPole_build(entity)
	if entity.type ~= "electric-pole" then
		return
	end
	
	-- diconnect all circuit poles
	local disconnected = 0 
	for k,e in pairs(entity.neighbours.copper) do
		if e.name == "circuit-pole" then
			entity.disconnect_neighbour(e)
			disconnected = disconnected + 1
		end
	end
	-- make some connnections if all have been removed
	if #entity.neighbours.copper > 0 or disconnected==0 then
		return
	end
	
	local searchArea = {{entity.position.x-20, entity.position.y-20}, {entity.position.x+20, entity.position.y+20}}
	local entities = entity.surface.find_entities_filtered{type="electric-pole",area = searchArea}
	for _,e in pairs(entities) do
		if e.name ~= "circuit-pole" then
			entity.connect_neighbour(e)
		end
		if # entity.neighbours.copper >= 2 then
			break
		end
	end
	
end


---------------------------------------------------
-- build and remove
---------------------------------------------------

circuitPole.build = function(entity)
	
	entity.disconnect_neighbour()
	return {
	}
end

