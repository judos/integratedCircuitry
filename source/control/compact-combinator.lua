
-- Registering entity into system
local entityMethods = {}
entities["compact-combinator"] = entityMethods

-- Constants
local m = {} --used for methods of the entity

---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
--		output = constant-combinator which is used as output
-- }

--------------------------------------------------
-- Global data
--------------------------------------------------


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
	
	game.create_surface("circuit",{
		terrain_segmentation="none",water="none",autoplace_controls={},width=10,height=10
	})
	local surface = game.surfaces["circuit"]
	surface.request_to_generate_chunks({0,0}, 32)
	
	return {
		io = io,
		surface = surface
	}
end

entityMethods.remove = function(data)
	if data.io then
		for i=1,4 do
			data.io[i].destroy()
		end
	end
	if data.surface and data.surface.valid then
		game.delete_surface(data.surface.name)
	end
end

entityMethods.copy = function(source,srcData,target,targetData)
	
end

---------------------------------------------------
-- gui actions
---------------------------------------------------


---------------------------------------------------
-- update tick
---------------------------------------------------

entityMethods.tick = function(entity,data)
	if not data then
		err("Error occured with status-panel: "..idOfEntity(filterCombinator))
		return 0,nil
	end
	if not data.checked and data.surface.is_chunk_generated({0,0}) then
		m.removeAllSurfaceEntities(data.surface)
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
		surface=data.surface,force=data.io[1].force,position={0,0},
		force_build=true
	}
	local entities = data.surface.find_entities({{-10,-10},{10,10}})
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

m.removeAllSurfaceEntities = function(surface)
	surface.destroy_decoratives({{-10,-10},{10,10}})
	local entities = surface.find_entities({{-10,-10},{10,10}})
	for _,x in pairs(entities) do
		x.destroy()
	end
	err("Surface created, entities removed...")
end

