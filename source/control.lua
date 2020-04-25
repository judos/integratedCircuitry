require "libs.all"
require "libs.prototypes.all"
require "libs.control.functions"

require "constants"

require "control.status-panel"
--require "control.filter-combinator"
require "control.circuit-pole"
require "control.compact-combinator"
require "control.compact-combinator-allowedBuildings"
require "control.compact-combinator-ghost"
require "control.monochrom-display-row"
require "control.color-display-row"


-- global data used:
-- integratedCircuitry.version = $version
-- integratedCircuitry.surface:
--    See compact-combinator-surface.lua
-- integratedCircuitry.cc:
--    See compact-combinator.lua

---------------------------------------------------
-- Init
---------------------------------------------------
script.on_init(function()
	if not global.integratedCircuitry then global.integratedCircuitry = {} end
	local data = global.integratedCircuitry
	if not data.version then data.version = modVersion end
	
	entities_init()
	gui_init()
end)

script.on_load(function()
	entities_load()
end)

script.on_configuration_changed(function()
	gui_init()
	entities_init()
	local ic = global.integratedCircuitry
	local previousVersion = ic.version
	if ic.version < "0.1.1" then
		err("Migration from version "..ic.version.." not supported!")
	end
	if ic.version ~= previousVersion then
		info("Previous version: "..previousVersion.." migrated to "..ic.version)
	end
end)

---------------------------------------------------
-- Tick
---------------------------------------------------
script.on_event(defines.events.on_tick, function(event)
	entities_tick()
	gui_tick()
end)

---------------------------------------------------
-- Building Entities
---------------------------------------------------

function on_built(event)
	local player = nil
	if event.player_index then
		player = game.players[event.player_index]
	end
	entities_build(event)
	
	local entity = event.created_entity or event.entity or event.destination
	compactCombinator_checkSurfaceBuildings(entity, player)
	-- disconnect power cables to io-ports only meant for circuit cables
	circuitPole_build_electric_pole(entity) 
end
script.on_event(defines.events.on_built_entity, on_built)
script.on_event(defines.events.on_robot_built_entity, on_built)
script.on_event(defines.events.script_raised_built, on_built)
script.on_event(defines.events.script_raised_revive, on_built)
script.on_event(defines.events.on_entity_cloned , on_built)

---------------------------------------------------
-- Removing entities
---------------------------------------------------
script.on_event(defines.events.on_robot_pre_mined, entities_pre_mined)
script.on_event(defines.events.on_pre_player_mined_item, entities_pre_mined)

script.on_event(defines.events.on_entity_died, entities_died)
script.on_event(defines.events.script_raised_destroy, entities_died)

---------------------------------------------------
-- Settings / Deconstruction
---------------------------------------------------

script.on_event(defines.events.on_entity_settings_pasted, function(event)
	entities_settings_pasted(event)
end)

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
	entities_marked_for_deconstruction(event)
end)

