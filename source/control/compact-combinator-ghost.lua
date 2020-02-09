-- Registering entity into system
local private = {} -- private methods
local entityMethods = {}
entities["entity-ghost"] = entityMethods





entityMethods.build = function(entity)
	if entity.ghost_name == "compact-combinator-io" then
		local x,revivedEntity = entity.revive()
		private.indestructible(revivedEntity)
	end

end






private.indestructible = function(entity)
	entity.destructible = false
	entity.minable = false
	entity.operable = false
end