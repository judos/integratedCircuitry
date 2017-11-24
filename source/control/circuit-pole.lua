require "libs.itemSelection.control"

-- Registering entity into system
local circuitPole = {}
entities["circuit-pole"] = circuitPole

-- Constants
local m = {} --used for methods of the circuitPole

---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
-- }

--------------------------------------------------
-- Global data
--------------------------------------------------


---------------------------------------------------
-- build and remove
---------------------------------------------------

circuitPole.build = function(entity)
	
	entity.disconnect_neighbour()
	return {
	}
end

