local math2d = require("math2d")
require "libs.lua.string"

-- Registering entity into system
local circuitPole = {}
entities["circuit-pole"] = circuitPole

function circuitPole_build_electric_pole(entity)
	if not entity.valid or entity.type ~= "electric-pole" then
		return
	end
	-- diconnect all circuit poles and measure distance to poles
	local d={}
	for k,e in pairs(entity.neighbours.copper) do
		entity.disconnect_neighbour(e)
		local distance = math2d.position.distance(entity.position, e.position)
		table.insert(d, { distance= distance, entity = e} )
	end
	
	table.sort(d, function(x, y)
		return x.distance < y.distance
	end)
	
	for _,arr in pairs(d) do
		local e = arr.entity
		entity.connect_neighbour(e)
		if # entity.neighbours.copper >= 2 then
			break
		end
	end
	
end


---------------------------------------------------
-- build and remove
---------------------------------------------------

circuitPole.build = function(entity)
	--entity.disconnect_neighbour()
	entity.operable = false
	return {
	}
end

