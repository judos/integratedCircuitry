require "libs.all"
require "libs.prototypes.all"
require "libs.control.functions"

require "constants"

require "control.status-panel"
require "control.filter-combinator"
require "control.circuit-pole"


-- global data used:
-- integratedCircuitry.version = $version

---------------------------------------------------
-- Init
---------------------------------------------------
script.on_init(function()
	if not global.integratedCircuitry then global.integratedCircuitry = {} end
	local bs = global.integratedCircuitry
	if not bs.version then bs.version = modVersion end
	
	entities_init()
	gui_init()
	
end)

script.on_load(function()
	info(global)
end)

script.on_configuration_changed(function()
	local bs = global.integratedCircuitry
	local previousVersion = bs.version
	if bs.version ~= previousVersion then
		info("Previous version: "..previousVersion.." migrated to "..bs.version)
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
script.on_event(defines.events.on_built_entity, function(event)
	--info(event.created_entity.type)
	entities_build(event)
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
	entities_build(event)
end)

---------------------------------------------------
-- Removing entities
---------------------------------------------------
script.on_event(defines.events.on_robot_pre_mined, function(event)
	entities_pre_mined(event)
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	entities_pre_mined(event)
end)

---------------------------------------------------
-- Removing entities
---------------------------------------------------

script.on_event(defines.events.on_entity_settings_pasted, function(event)
	entities_settings_pasted(event)
end)

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
	entities_marked_for_deconstruction(event)
end)

