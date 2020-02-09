-- Registering entity into system
local private = {} -- private methods
local entityMethods = {}
entities["entity-ghost"] = entityMethods





entityMethods.build = function(entity)
	if entity.ghost_name == "compact-combinator-io" then
		local x,revivedEntity = entity.revive()
		private.indestructible(revivedEntity)
		return
	end
	if entity.ghost_name == "compact-combinator" then
		scheduleAdd(entity,TICK_SOON) -- tick to get notified if it doesn't exist anymore
		return {
			pos = entity.position,
			surface = entity.surface
		}
	end
end

entityMethods.tick = function(entity,data)
	return 30,nil -- next tick, reason
end


entityMethods.remove = function(data)
	local pos = data.pos
	local ports = data.surface.find_entities_filtered{
		area={{pos.x-1,pos.y-1},{pos.x+1,pos.y+1}}, 
		name="compact-combinator-io",
	}
	for k,v in pairs(ports) do
		v.destroy()
	end

end





private.indestructible = function(entity)
	entity.destructible = false
	entity.minable = false
	entity.operable = false
end