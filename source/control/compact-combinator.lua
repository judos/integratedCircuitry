local Surface = require("control.compact-combinator-surface")

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
--		version = 1 (in the current version)
--		io = {[1]=... [4]=..} constant-combinator which is used as input/output
--		size = size of the blueprint used (in the current version 10x10)
--    chunkPos = position of the center of the blueprint (usally expands by {{-5,-5},{4,4}}
--		state = enum(
--			"chunk-gen" generation of chunk requested
--			"empty"			chunk and tiles generated
--			"built"			blueprint is built and connected
--		)
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
		local data = global.entityData[idOfEntity(entity)]
		player.teleport({data.chunkPos[1]*32+16,data.chunkPos[2]*32+16},Surface.get())
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
	
	-- generate surface if not existed yet
	local surface = Surface.get()
	
	return {
		version = 1,
		io = io,
		size = 10,
		chunkPos = Surface.newSpot(),
		state = "chunk-gen"
	}
end


entityMethods.remove = function(data)
	if data.io then
		for i=1,4 do
			data.io[i].destroy()
		end
	end
	Surface.freeSpot(data.chunkPos)
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
	
	if data.state == "chunk-gen" then
		if Surface.get().is_chunk_generated({0,0}) then
			Surface.placeTiles(data.chunkPos)
			data.state = "empty"
			info("chunk generated: "..serpent.block(data.chunkPos))
		else
			info("waiting for chunk gen: "..serpent.block(data.chunkPos))
		end
	end
	if data.state == "empty" then
		local item = m.getValidBlueprintItem(entity)
		if item~=nil then
			Surface.buildBlueprint(data.chunkPos,item,data.io[1].force)
			data.state = "built"
			info("Blueprint built")
		else
			warn("no valid blueprint item inserted")
		end
	end
	
	return 10
end


m.getValidBlueprintItem = function(entity)
	--local inv = entity.get_inventory(defines.inventory.chest)
	if inv~=nil and not inv.is_empty() then
		local item = inv[1]
		if item.valid then
			if item.is_blueprint_setup() then
				return item
			end
		end
	end
	return nil
end


