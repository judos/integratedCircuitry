
-- Registering entity into system
local entityMethods = {}
entities["compact-combinator"] = entityMethods
local guiMethods = {}
gui["compact-combinator"] = guiMethods

-- Constants
local m = {} --private methods

---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
--		io = constant-combinator which is used as input/output
-- }

--------------------------------------------------
-- Gui testing
--------------------------------------------------
local teleportButtonName = "integratedCircuitry.compact-combinator"

guiMethods.open = function(player, entity)
	player.gui.left.add{type="button",name=teleportButtonName,caption="Teleport"}
end

guiMethods.close = function(player)
	if player.gui.left[teleportButtonName] then
		player.gui.left[teleportButtonName].destroy()
	end
end

guiMethods.click = function(nameArr, player, entity)
	local button = table.remove(nameArr,1)
	if button == "compact-combinator" then
		player.teleport({0,0},m.getCircuitSurface())
		player.gui.left[teleportButtonName].destroy()
		player.gui.left.add{type="button",name="integratedCircuitry.compact-combinator-back",caption="Teleport back"}
	elseif button == "compact-combinator-back" then
		player.teleport({0,0},game.surfaces["nauvis"])
		player.gui.left[teleportButtonName.."-back"].destroy()
	end
end

---------------------------------------------------
-- build and remove
---------------------------------------------------

entityMethods.build = function(entity)
	scheduleAdd(entity, TICK_ASAP)
	local position = entity.position
	
	local io = {}
	local ox = 0.25
	local oy = 0.35
	io[1] = entity.surface.create_entity{
		name="compact-combinator-io", position= {x=position.x-ox , y=position.y-oy}, force=entity.force
	}
	io[2] = entity.surface.create_entity{
		name="compact-combinator-io", position= {x=position.x+ox , y=position.y-oy}, force=entity.force
	}
	io[3] = entity.surface.create_entity{
		name="compact-combinator-io", position= {x=position.x-ox , y=position.y+oy}, force=entity.force
	}
	io[4] = entity.surface.create_entity{
		name="compact-combinator-io", position= {x=position.x+ox , y=position.y+oy}, force=entity.force
	}
	for i=1,4 do
		io[i].destructible = false
		io[i].minable = false
		io[i].operable = false
	end
	
	local surface = m.getCircuitSurface()
	
	return {
		io = io,
	}
end

m.getCircuitSurface = function()
	local surfaceName = "compact-circuits"
	local surface = game.surfaces[surfaceName]
	if surface~=nil then return surface end
	game.create_surface(surfaceName,{
		terrain_segmentation="none",water="none",autoplace_controls={}
	})
	surface = game.surfaces[surfaceName]
	surface.request_to_generate_chunks({0,0}, 32)
	return game.surfaces[surfaceName]
end

entityMethods.remove = function(data)
	if data.io then
		for i=1,4 do
			data.io[i].destroy()
		end
	end
end

entityMethods.copy = function(source,srcData,target,targetData)
	
end

---------------------------------------------------
-- update tick
---------------------------------------------------

entityMethods.tick = function(entity,data)
	if not data then
		err("Error occured with status-panel: "..idOfEntity(filterCombinator))
		return 0,nil
	end
	if not data.checked and m.getCircuitSurface().is_chunk_generated({0,0}) then
		m.removeAllSurfaceEntities()
		data.checked = true
	end
	
	local item = m.getValidBlueprintItem(entity)
	if item~=nil and data.checked and not data.built then
		print(serpent.block(item.get_blueprint_entities()))
		m.buildAndReviveBlueprint(item,data)
		data.built = true
		err("Blueprint built")
	end
	
	return 10
end

m.buildAndReviveBlueprint = function(item,data)
	item.build_blueprint{
		surface=m.getCircuitSurface(),force=data.io[1].force,position={0,0},
		force_build=true
	}
	local entities = m.getCircuitSurface().find_entities({{-10,-10},{10,10}})
	for _,x in pairs(entities) do
		x.revive()
	end
end

m.getValidBlueprintItem = function(entity)
	local inv = entity.get_inventory(defines.inventory.chest)
	if not inv.is_empty() then
		local item = inv[1]
		if item.valid then
			if item.is_blueprint_setup() then
				return item
			end
		end
	end
	return nil
end

m.removeAllSurfaceEntities = function()
	m.getCircuitSurface().destroy_decoratives({{-10,-10},{10,10}})
	local entities = m.getCircuitSurface().find_entities()
	for _,x in pairs(entities) do
		x.destroy()
	end
	err("Surface created, entities removed...")
end

