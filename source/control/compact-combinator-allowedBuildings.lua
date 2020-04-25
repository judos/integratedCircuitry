local Surface = require("control.compact-combinator-surface")
require "libs.control.luaentity"

function compactCombinator_checkSurfaceBuildings(entity, player)
	--if an earlier event handler removed entity return here
	--also if it's not on compact-combinator surface
	if not entity.valid or entity.surface.name ~= Surface.name then
		return
	end
	
	local t = entity.type
	local n = entity.name
	if n~="compact-combinator" then
		if n=="circuit-pole" or n=="signpost" or n=="entity-ghost" then
			return
		end
		if t=="constant-combinator" or t=="decider-combinator" or t=="arithmetic-combinator" or t=="lamp"
				or t=="programmable-speaker" or t=="wall" or t=="gate" then
			return
		end
	end
	
	entity.surface.create_entity{
		name="tutorial-flying-text", text={"compact-combinator.can-only-place-combinator"}, position=entity.position
	}
	-- if it was an electric pole disconnect copper-cables first otherwise it looks ugly
	-- because copper-cables are then reorganized to ports..
	if t=="electric-pole" then
		entity.disconnect_neighbour()
	end
	removeEntity(entity, player)
end