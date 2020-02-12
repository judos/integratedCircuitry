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
		migrate_0_1_1()
		ic.version = "0.1.1"
	end
	if ic.version ~= previousVersion then
		info("Previous version: "..previousVersion.." migrated to "..ic.version)
	end
end)

function migrate_0_1_1()
	migrate_0_1_1_statusPanel()
end

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
script.on_event(defines.events.on_built_entity, function(event)
	local player = game.players[event.player_index]
	entities_build(event)
	compactCombinator_checkSurfaceBuildings(event.created_entity, player)
	-- disconnect power cables to io-ports only meant for circuit cables
	circuitPole_build_electric_pole(event.created_entity) 
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
	local player = nil
	entities_build(event)
	compactCombinator_checkSurfaceBuildings(event.created_entity, player)
	-- disconnect power cables to io-ports only meant for circuit cables
	circuitPole_build_electric_pole(event.created_entity) 
end)

---------------------------------------------------
-- Removing entities
---------------------------------------------------
script.on_event(defines.events.on_robot_pre_mined, function(event)
	entities_pre_mined(event)
end)

script.on_event(defines.events.on_pre_player_mined_item, function(event)
	entities_pre_mined(event)
end)

script.on_event(defines.events.on_entity_died, function(event)
	entities_died(event)
end)

---------------------------------------------------
-- Settings / Deconstruction
---------------------------------------------------

script.on_event(defines.events.on_entity_settings_pasted, function(event)
	entities_settings_pasted(event)
end)

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
	entities_marked_for_deconstruction(event)
end)

